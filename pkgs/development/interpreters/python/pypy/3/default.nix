{ stdenv, substituteAll, fetchurl
, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, python, expat, tcl, tk, tix, xlibsWrapper, libX11
, makeWrapper, callPackage, self, gdbm, db, lzma
, python-setup-hook
# For the Python package set
, packageOverrides ? (self: super: {})
}:

assert zlibSupport -> zlib != null;

let
  version = "6.0.0";
  pythonVersion = "3.5";
  libPrefix = "pypy${pythonVersion}";
  sitePackages = "site-packages";

  pythonForPypy = python.withPackages (ppkgs: [ ppkgs.pycparser ]);

in stdenv.mkDerivation rec {
  name = "pypy3-${version}";
  inherit version pythonVersion;

  src = fetchurl {
    url = "https://bitbucket.org/pypy/pypy/get/release-pypy${pythonVersion}-v${version}.tar.bz2";
    sha256 = "0lwq8nn0r5yj01bwmkk5p7xvvrp4s550l8184mkmn74d3gphrlwg";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [
    bzip2 openssl pythonForPypy libffi ncurses expat sqlite tk tcl xlibsWrapper libX11 gdbm db lzma
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
    substituteInPlace "lib-python/3/tkinter/tix.py" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"

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
      --batch pypy/goal/targetpypystandalone.py
  '';

  setupHook = python-setup-hook sitePackages;

  doCheck = true;
  checkPhase = ''
    export TERMINFO="${ncurses.out}/share/terminfo/";
    export TERM="xterm";
    export HOME="$TMPDIR";
    # disable asyncio due to https://github.com/NixOS/nix/issues/1238
    # disable os due to https://github.com/NixOS/nixpkgs/issues/10496
    # disable pathlib due to https://bitbucket.org/pypy/pypy/pull-requests/594
    # disable shutils because it assumes gid 0 exists
    # disable socket because it has two actual network tests that fail
    # disable tarfile because it assumes gid 0 exists
    ${pythonForPypy.interpreter} ./pypy/test_all.py --pypy=./pypy3-c -k 'not ( test_asyncio or test_os or test_pathlib or test_shutil or test_socket or test_tarfile )' lib-python
  '';

  installPhase = ''
    mkdir -p $out/{bin,include,lib,pypy3-c}

    cp -R {include,lib_pypy,lib-python,pypy3-c} $out/pypy3-c
    cp libpypy3-c.so $out/lib/
    ln -s $out/pypy3-c/pypy3-c $out/bin/pypy3

    # other packages expect to find stuff according to libPrefix
    ln -s $out/pypy3-c/include $out/include/${libPrefix}
    ln -s $out/pypy3-c/lib-python/3 $out/lib/${libPrefix}

    # We must wrap the original, not the symlink.
    # PyPy uses argv[0] to find its standard library, and while it knows
    # how to follow symlinks, it doesn't know about wrappers. So, it
    # will think the wrapper is the original. As long as the wrapper has
    # the same path as the original, this is OK.
    wrapProgram "$out/pypy3-c/pypy3-c" \
      --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:$out/lib" \
      --set LIBRARY_PATH "${LIBRARY_PATH}:$out/lib"

    # verify cffi modules
    $out/bin/pypy3 -c "import tkinter;import sqlite3;import curses;import lzma"

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py
  '';

  passthru = let
    pythonPackages = callPackage ../../../../../top-level/python-packages.nix {python=self; overrides=packageOverrides;};
  in rec {
    inherit zlibSupport libPrefix sitePackages;
    executable = "pypy3";
    isPypy = true;
    isPy3 = true;
    isPy35 = true;
    buildEnv = callPackage ../../wrapper.nix { python = self; inherit (pythonPackages) requiredPythonModules; };
    interpreter = "${self}/bin/${executable}";
    withPackages = import ../../with-packages.nix { inherit buildEnv pythonPackages;};
    pkgs = pythonPackages;
  };

  enableParallelBuilding = true;  # almost no parallelization without STM

  meta = with stdenv.lib; {
    homepage = http://pypy.org/;
    description = "Fast, compliant alternative implementation of the Python language (3.5.3)";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ andersk ];
  };
}
