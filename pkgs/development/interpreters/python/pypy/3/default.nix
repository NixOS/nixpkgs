{ stdenv, substituteAll, fetchurl
, zlib, bzip2, pkgconfig, libffi, gdbm, db, lzma
, sqlite, openssl, ncurses, expat, tcl, tk, tix, xlibsWrapper, libX11
, python, python-setup-hook, makeWrapper, callPackage
# For the Python package set
, self, packageOverrides ? (self: super: {})
}:

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

  nativeBuildInputs = [ pkgconfig makeWrapper pythonForPypy ];
  buildInputs = [
    bzip2 openssl libffi ncurses expat sqlite tk tcl xlibsWrapper libX11 gdbm db lzma zlib
  ];

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "pic";

  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath buildInputs;

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
    substituteInPlace "lib-python/3/tkinter/tix.py" \
      --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY', '${tix}/lib')"
  '';

  buildPhase = ''
    pushd pypy/goal
    # TODO: this will not work for the cross-compiling case
    ${pythonForPypy.interpreter} ../../rpython/bin/rpython \
      --make-jobs="$NIX_BUILD_CORES" \
      -Ojit --shared \
      targetpypystandalone
    PYTHONPATH=../.. ./pypy3-c ../tool/build_cffi_imports.py
    popd
  '';

  setupHook = python-setup-hook sitePackages;

  installPhase = ''
    ${pythonForPypy.interpreter} pypy/tool/release/package.py --archive-name pypy --targetdir .
    mkdir -p $out/{bin,include,lib,share/pypy}
    tar xf pypy.tar.bz2 -C $out/share/

    ln -s $out/share/pypy/bin/pypy3 $out/bin/pypy3
    ln -s $out/share/pypy/lib/libpypy3-c.so $out/lib/libpypy3-c.so
    # other packages expect to find stuff according to libPrefix
    ln -s $out/share/pypy/include $out/include/${libPrefix}
    ln -s $out/share/pypy/lib-python/3 $out/lib/${libPrefix}

    # verify cffi modules
    LD_LIBRARY_PATH= $out/bin/pypy3 -c "import tkinter;import sqlite3;import curses;import lzma"

    ## Python on Nix is not manylinux1 compatible. https://github.com/NixOS/nixpkgs/issues/18484
    echo "manylinux1_compatible=False" >> $out/lib/${libPrefix}/_manylinux.py
  '';

  passthru = let
    pythonPackages = callPackage ../../../../../top-level/python-packages.nix {python=self; overrides=packageOverrides;};
  in rec {
    inherit libPrefix sitePackages;
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
