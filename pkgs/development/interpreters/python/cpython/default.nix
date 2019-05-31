{ stdenv, fetchurl, fetchpatch
, bzip2
, expat
, libffi
, gdbm
, lzma
, ncurses
, openssl
, readline
, sqlite
, tcl ? null, tk ? null, tix ? null, libX11 ? null, xorgproto ? null, x11Support ? false
, zlib
, callPackage
, self
, CF, configd
, python-setup-hook
, nukeReferences
# For the Python package set
, packageOverrides ? (self: super: {})
, buildPackages
, sourceVersion
, sha256
, passthruFun
, bash
}:

assert x11Support -> tcl != null
                  && tk != null
                  && xorgproto != null
                  && libX11 != null;
with stdenv.lib;

let

  passthru = passthruFun rec {
    inherit self sourceVersion packageOverrides;
    implementation = "cpython";
    libPrefix = "python${pythonVersion}";
    executable = libPrefix;
    pythonVersion = with sourceVersion; "${major}.${minor}";
    sitePackages = "lib/${libPrefix}/site-packages";
    inherit hasDistutilsCxxPatch pythonForBuild;
  };

  version = with sourceVersion; "${major}.${minor}.${patch}${suffix}";

  nativeBuildInputs = [
    nukeReferences
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    buildPackages.stdenv.cc
    pythonForBuild
  ];

  buildInputs = filter (p: p != null) [
    zlib bzip2 expat lzma libffi gdbm sqlite readline ncurses openssl ]
    ++ optionals x11Support [ tcl tk libX11 xorgproto ]
    ++ optionals stdenv.isDarwin [ CF configd ];

  hasDistutilsCxxPatch = !(stdenv.cc.isGNU or false);

  pythonForBuild = buildPackages.${"python${sourceVersion.major}${sourceVersion.minor}"};

  pythonForBuildInterpreter = if stdenv.hostPlatform == stdenv.buildPlatform then
    "$out/bin/python"
  else pythonForBuild.interpreter;

in with passthru; stdenv.mkDerivation {
  pname = "python3";
  inherit version;

  inherit buildInputs nativeBuildInputs;

  src = fetchurl {
    url = with sourceVersion; "https://www.python.org/ftp/python/${major}.${minor}.${patch}/Python-${version}.tar.xz";
    inherit sha256;
  };

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
    substituteInPlace configure --replace '-Wl,-stack_size,1000000' ' '
  '';

  patches = [
    # Disable the use of ldconfig in ctypes.util.find_library (since
    # ldconfig doesn't work on NixOS), and don't use
    # ctypes.util.find_library during the loading of the uuid module
    # (since it will do a futile invocation of gcc (!) to find
    # libuuid, slowing down program startup a lot).
    (./. + "/${sourceVersion.major}.${sourceVersion.minor}/no-ldconfig.patch")
  ] ++ optionals (isPy35 || isPy36) [
    # Determinism: Write null timestamps when compiling python files.
    ./3.5/force_bytecode_determinism.patch
  ] ++ optionals isPy35 [
    # Backports support for LD_LIBRARY_PATH from 3.6
    ./3.5/ld_library_path.patch
  ] ++ optionals isPy37 [
    # Fix darwin build https://bugs.python.org/issue34027
    (fetchpatch {
      url = https://bugs.python.org/file47666/darwin-libutil.patch;
      sha256 = "0242gihnw3wfskl4fydp2xanpl8k5q7fj4dp7dbbqf46a4iwdzpa";
    })
  ] ++ optionals (isPy3k && hasDistutilsCxxPatch) [
    # Fix for http://bugs.python.org/issue1222585
    # Upstream distutils is calling C compiler to compile C++ code, which
    # only works for GCC and Apple Clang. This makes distutils to call C++
    # compiler when needed.
    (
      if isPy35 then
        ./3.5/python-3.x-distutils-C++.patch
      else if isPy37 then
        ./3.7/python-3.x-distutils-C++.patch
      else
        fetchpatch {
          url = "https://bugs.python.org/file48016/python-3.x-distutils-C++.patch";
          sha256 = "1h18lnpx539h5lfxyk379dxwr8m2raigcjixkf133l4xy3f4bzi2";
        }
    )
  ];

  postPatch = ''
  '' + optionalString (x11Support && (tix != null)) ''
    substituteInPlace "Lib/tkinter/tix.py" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"
  '';

  CPPFLAGS = "${concatStringsSep " " (map (p: "-I${getDev p}/include") buildInputs)}";
  LDFLAGS = "${concatStringsSep " " (map (p: "-L${getLib p}/lib") buildInputs)}";
  LIBS = "${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}";
  NIX_LDFLAGS = optionalString stdenv.isLinux "-lgcc_s";
  # Determinism: We fix the hashes of str, bytes and datetime objects.
  PYTHONHASHSEED=0;

  configureFlags = [
    "--enable-shared"
    "--with-threads"
    "--without-ensurepip"
    "--with-system-expat"
    "--with-system-ffi"
    "--with-openssl=${openssl.dev}"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_buggy_getaddrinfo=no"
    # Assume little-endian IEEE 754 floating point when cross compiling
    "ac_cv_little_endian_double=yes"
    "ac_cv_big_endian_double=no"
    "ac_cv_mixed_endian_double=no"
    "ac_cv_x87_double_rounding=yes"
    "ac_cv_tanh_preserves_zero_sign=yes"
    # Generally assume that things are present and work
    "ac_cv_posix_semaphores_enabled=yes"
    "ac_cv_broken_sem_getvalue=no"
    "ac_cv_wchar_t_signed=yes"
    "ac_cv_rshift_extends_sign=yes"
    "ac_cv_broken_nice=no"
    "ac_cv_broken_poll=no"
    "ac_cv_working_tzset=yes"
    "ac_cv_have_long_long_format=yes"
    "ac_cv_have_size_t_format=yes"
    "ac_cv_computed_gotos=yes"
    "ac_cv_file__dev_ptmx=yes"
    "ac_cv_file__dev_ptc=yes"
  ] ++ optionals stdenv.hostPlatform.isLinux [
    # Never even try to use lchmod on linux,
    # don't rely on detecting glibc-isms.
    "ac_cv_func_lchmod=no"
  ];

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  '' + optionalString stdenv.isDarwin ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"
    export MACOSX_DEPLOYMENT_TARGET=10.6
  '' + optionalString (isPy3k && pythonOlder "3.7") ''
    # Determinism: The interpreter is patched to write null timestamps when compiling Python files
    #   so Python doesn't try to update the bytecode when seeing frozen timestamps in Nix's store.
    export DETERMINISTIC_BUILD=1;
  '' + optionalString stdenv.hostPlatform.isMusl ''
    export NIX_CFLAGS_COMPILE+=" -DTHREAD_STACK_SIZE=0x100000"
  '';

  setupHook = python-setup-hook sitePackages;

  postInstall = ''
    # needed for some packages, especially packages that backport functionality
    # to 2.x from 3.x
    for item in $out/lib/${libPrefix}/test/*; do
      if [[ "$item" != */test_support.py*
         && "$item" != */test/support
         && "$item" != */test/libregrtest
         && "$item" != */test/regrtest.py* ]]; then
        rm -rf "$item"
      else
        echo $item
      fi
    done
    touch $out/lib/${libPrefix}/test/__init__.py

    ln -s "$out/include/${executable}m" "$out/include/${executable}"

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py

    # Determinism: Windows installers were not deterministic.
    # We're also not interested in building Windows installers.
    find "$out" -name 'wininst*.exe' | xargs -r rm -f

    # Use Python3 as default python
    ln -s "$out/bin/idle3" "$out/bin/idle"
    ln -s "$out/bin/pydoc3" "$out/bin/pydoc"
    ln -s "$out/bin/python3" "$out/bin/python"
    ln -s "$out/bin/python3-config" "$out/bin/python-config"
    ln -s "$out/lib/pkgconfig/python3.pc" "$out/lib/pkgconfig/python.pc"

    # Get rid of retained dependencies on -dev packages, and remove
    # some $TMPDIR references to improve binary reproducibility.
    # Note that the .pyc file of _sysconfigdata.py should be regenerated!
    for i in $out/lib/${libPrefix}/_sysconfigdata*.py $out/lib/${libPrefix}/config-${sourceVersion.major}${sourceVersion.minor}*/Makefile; do
       sed -i $i -e "s|$TMPDIR|/no-such-path|g"
    done

    # Further get rid of references. https://github.com/NixOS/nixpkgs/issues/51668
    find $out/lib/python*/config-* -type f -print -exec nuke-refs -e $out '{}' +
    find $out/lib -name '_sysconfigdata*.py*' -print -exec nuke-refs -e $out '{}' +

    # Determinism: rebuild all bytecode
    # We exclude lib2to3 because that's Python 2 code which fails
    # We rebuild three times, once for each optimization level
    # Python 3.7 implements PEP 552, introducing support for deterministic bytecode.
    # This is automatically used when `SOURCE_DATE_EPOCH` is set.
    find $out -name "*.py" | ${pythonForBuildInterpreter}     -m compileall -q -f -x "lib2to3" -i -
    find $out -name "*.py" | ${pythonForBuildInterpreter} -O  -m compileall -q -f -x "lib2to3" -i -
    find $out -name "*.py" | ${pythonForBuildInterpreter} -OO -m compileall -q -f -x "lib2to3" -i -
  '';

  preFixup = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # Ensure patch-shebangs uses shebangs of host interpreter.
    export PATH=${stdenv.lib.makeBinPath [ "$out" bash ]}:$PATH
  '';

  # Enforce that we don't have references to the OpenSSL -dev package, which we
  # explicitly specify in our configure flags above.
  disallowedReferences = [
    openssl.dev
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # Ensure we don't have references to build-time packages.
    # These typically end up in shebangs.
    pythonForBuild buildPackages.bash
  ];

  inherit passthru;

  enableParallelBuilding = true;

  meta = {
    homepage = http://python.org;
    description = "A high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = licenses.psfl;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ fridh ];
  };
}
