{ stdenv, substituteAll, fetchurl
, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, python, expat, tcl, tk, tix, xlibsWrapper, libX11
, makeWrapper, callPackage, self, gdbm, db
, python-setup-hook
# For the Python package set
, pkgs, packageOverrides ? (self: super: {})
}:

assert zlibSupport -> zlib != null;

let
  majorVersion = "5.9";
  minorVersion = "0";
  minorVersionSuffix = "";
  pythonVersion = "2.7";
  version = "${majorVersion}.${minorVersion}${minorVersionSuffix}";
  libPrefix = "pypy${majorVersion}";
  sitePackages = "site-packages";

  pythonForPypy = python.withPackages (ppkgs: [ ppkgs.pycparser ]);

in stdenv.mkDerivation rec {
  name = "pypy-${version}";
  inherit majorVersion version pythonVersion;

  src = fetchurl {
    url = "https://bitbucket.org/pypy/pypy/get/release-pypy${pythonVersion}-v${version}.tar.bz2";
    sha256 = "1q3kcnniyvnca1l7x10mbhp4xwjr03ajh2h8j6cbdllci38zdjy1";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [
    bzip2 openssl pythonForPypy libffi ncurses expat sqlite tk tcl xlibsWrapper libX11 gdbm db
  ] ++ stdenv.lib.optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc
    ++ stdenv.lib.optional zlibSupport zlib;

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "pic";

  C_INCLUDE_PATH = stdenv.lib.makeSearchPathOutput "dev" "include" buildInputs;
  LIBRARY_PATH = stdenv.lib.makeLibraryPath buildInputs;
  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath (stdenv.lib.filter (x : x.outPath != stdenv.cc.libc.outPath or "") buildInputs);

  patches = [
    (substituteAll {
      src = ./tk_tcl_paths.patch;
      inherit tk tcl;
      tk_dev = tk.dev;
      tcl_dev = tcl;
      tk_libprefix = tk.libPrefix;
      tcl_libprefix = tcl.libPrefix;
    })
  ];

  postPatch = ''
    substituteInPlace "lib-python/2.7/lib-tk/Tix.py" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"

    # hint pypy to find nix ncurses
    substituteInPlace pypy/module/_minimal_curses/fficurses.py \
      --replace "/usr/include/ncurses/curses.h" "${ncurses.dev}/include/curses.h" \
      --replace "ncurses/curses.h" "${ncurses.dev}/include/curses.h" \
      --replace "ncurses/term.h" "${ncurses.dev}/include/term.h" \
      --replace "libraries=['curses']" "libraries=['ncurses']"

    sed -i "s@libraries=\['sqlite3'\]\$@libraries=['sqlite3'], include_dirs=['${sqlite.dev}/include'], library_dirs=['${sqlite.out}/lib']@" lib_pypy/_sqlite3_build.py
  '';

  buildPhase = ''
    ${pythonForPypy.interpreter} rpython/bin/rpython \
      --make-jobs="$NIX_BUILD_CORES" \
      -Ojit \
      --batch pypy/goal/targetpypystandalone.py \
      --withmod-_minimal_curses \
      --withmod-unicodedata \
      --withmod-thread \
      --withmod-bz2 \
      --withmod-_multiprocessing
  '';

  setupHook = python-setup-hook sitePackages;

  postBuild = ''
    pushd ./lib_pypy
    ../pypy-c ./_audioop_build.py
    ../pypy-c ./_curses_build.py
    ../pypy-c ./_pwdgrp_build.py
    ../pypy-c ./_sqlite3_build.py
    ../pypy-c ./_syslog_build.py
    ../pypy-c ./_tkinter/tklib_build.py
    popd
  '';

  doCheck = true;
  checkPhase = ''
    export TERMINFO="${ncurses.out}/share/terminfo/";
    export TERM="xterm";
    export HOME="$TMPDIR";
    # disable shutils because it assumes gid 0 exists
    # disable socket because it has two actual network tests that fail
    # disable test_urllib2net, test_urllib2_localnet, and test_urllibnet because they require networking (example.com)
    # disable test_ssl because no shared cipher' not found in '[Errno 1] error:14077410:SSL routines:SSL23_GET_SERVER_HELLO:sslv3 alert handshake failure
    # disable test_zipfile64 because it causes ENOSPACE
    ./pypy-c ./pypy/test_all.py --pypy=./pypy-c -k 'not ( test_ssl or test_urllib2net or test_urllibnet or test_urllib2_localnet or test_socket or test_shutil or test_zipfile64 )' lib-python
  '';

  installPhase = ''
    mkdir -p $out/{bin,include,lib,pypy-c}

    cp -R {include,lib_pypy,lib-python,pypy-c} $out/pypy-c
    cp libpypy-c.so $out/lib/
    ln -s $out/pypy-c/pypy-c $out/bin/pypy
    chmod +x $out/bin/pypy

    # other packages expect to find stuff according to libPrefix
    ln -s $out/pypy-c/include $out/include/${libPrefix}
    ln -s $out/pypy-c/lib-python/${pythonVersion} $out/lib/${libPrefix}

    # We must wrap the original, not the symlink.
    # PyPy uses argv[0] to find its standard library, and while it knows
    # how to follow symlinks, it doesn't know about wrappers. So, it
    # will think the wrapper is the original. As long as the wrapper has
    # the same path as the original, this is OK.
    wrapProgram "$out/pypy-c/pypy-c" \
      --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:$out/lib" \
      --set LIBRARY_PATH "${LIBRARY_PATH}:$out/lib"

    # verify cffi modules
    $out/bin/pypy -c "import Tkinter;import sqlite3;import curses"

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py
  '';

  passthru = let
    pythonPackages = callPackage ../../../../../top-level/python-packages.nix {python=self; overrides=packageOverrides;};
  in rec {
    inherit zlibSupport libPrefix sitePackages;
    executable = "pypy";
    isPypy = true;
    buildEnv = callPackage ../../wrapper.nix { python = self; inherit (pythonPackages) requiredPythonModules; };
    interpreter = "${self}/bin/${executable}";
    withPackages = import ../../with-packages.nix { inherit buildEnv pythonPackages;};
    pkgs = pythonPackages;
  };

  enableParallelBuilding = true;  # almost no parallelization without STM

  meta = with stdenv.lib; {
    homepage = http://pypy.org/;
    description = "Fast, compliant alternative implementation of the Python language (2.7.13)";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ domenkozar ];
  };
}
