{ stdenv, substituteAll, fetchurl
, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, python, expat, tcl, tk, tix, xlibsWrapper, libX11
, callPackage, self, gdbm, db, lzma
, python-setup-hook
# For the Python package set
, packageOverrides ? (self: super: {})
, sourceVersion
, pythonVersion
, sha256
, passthruFun
}:

assert zlibSupport -> zlib != null;

with stdenv.lib;

let
  isPy3k = substring 0 1 pythonVersion == "3";
  passthru = passthruFun rec {
    inherit self sourceVersion pythonVersion packageOverrides;
    implementation = "pypy";
    libPrefix = "pypy${pythonVersion}";
    executable = "pypy${if isPy3k then "3" else ""}";
    pythonForBuild = self; # No cross-compiling for now.
    sitePackages = "site-packages";
  };
  pname = passthru.executable;
  version = with sourceVersion; "${major}.${minor}.${patch}";
  pythonForPypy = python.withPackages (ppkgs: [ ppkgs.pycparser ]);

in with passthru; stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://bitbucket.org/pypy/pypy/get/release-pypy${pythonVersion}-v${version}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    bzip2 openssl pythonForPypy libffi ncurses expat sqlite tk tcl xlibsWrapper libX11 gdbm db
  ]  ++ optionals isPy3k [
    lzma
  ] ++ optionals (stdenv ? cc && stdenv.cc.libc != null) [
    stdenv.cc.libc
  ] ++ optionals zlibSupport [
    zlib
  ];

  hardeningDisable = optional stdenv.isi686 "pic";

  C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" buildInputs;
  LIBRARY_PATH = makeLibraryPath buildInputs;
  LD_LIBRARY_PATH = makeLibraryPath (filter (x : x.outPath != stdenv.cc.libc.outPath or "") buildInputs);

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
    substituteInPlace "lib-python/${if isPy3k then "3/tkinter/tix.py" else "2.7/lib-tk/Tix.py"}" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"

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
  checkPhase = let
    disabledTests = [
      # disable shutils because it assumes gid 0 exists
      "test_shutil"
      # disable socket because it has two actual network tests that fail
      "test_socket"
    ] ++ optionals (!isPy3k) [
      # disable test_urllib2net, test_urllib2_localnet, and test_urllibnet because they require networking (example.com)
      "test_urllib2net"
      "test_urllibnet"
      "test_urllib2_localnet"
    ] ++ optionals isPy3k [
      # disable asyncio due to https://github.com/NixOS/nix/issues/1238
      "test_asyncio"
      # disable os due to https://github.com/NixOS/nixpkgs/issues/10496
      "test_os"
      # disable pathlib due to https://bitbucket.org/pypy/pypy/pull-requests/594
      "test_pathlib"
      # disable tarfile because it assumes gid 0 exists
      "test_tarfile"
    ];
  in ''
    export TERMINFO="${ncurses.out}/share/terminfo/";
    export TERM="xterm";
    export HOME="$TMPDIR";

    ${pythonForPypy.interpreter} ./pypy/test_all.py --pypy=./${executable}-c -k 'not (${concatStringsSep " or " disabledTests})' lib-python
  '';

  installPhase = ''
    mkdir -p $out/{bin,include,lib,${executable}-c}

    cp -R {include,lib_pypy,lib-python,${executable}-c} $out/${executable}-c
    cp lib${executable}-c.so $out/lib/
    ln -s $out/${executable}-c/${executable}-c $out/bin/${executable}

    # other packages expect to find stuff according to libPrefix
    ln -s $out/${executable}/include $out/include/${libPrefix}
    ln -s $out/${executable}-c/lib-python/${if isPy3k then "3" else pythonVersion} $out/lib/${libPrefix}

    # verify cffi modules
    $out/bin/${executable} -c ${if isPy3k then "'import tkinter;import sqlite3;import curses;import lzma'" else "'import Tkinter;import sqlite3;import curses'"}

    # Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py
  '';

  inherit passthru;
  enableParallelBuilding = true;  # almost no parallelization without STM

  meta = with stdenv.lib; {
    homepage = http://pypy.org/;
    description = "Fast, compliant alternative implementation of the Python language (${pythonVersion})";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ andersk ];
  };
}
