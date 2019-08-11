{ stdenv, fetchurl, configd, CF, coreutils }:

with stdenv.lib;

let

  mkPaths = paths: {
    C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" paths;
    LIBRARY_PATH = makeLibraryPath paths;
  };

in

stdenv.mkDerivation rec {
  name = "python-boot-${version}";
  version = "2.7.12";
  libPrefix = "python2.7";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/2.7.12/Python-${version}.tar.xz";
    sha256 = "0y7rl603vmwlxm6ilkhc51rx2mfj14ckcz40xxgs0ljnvlhp30yp";
  };

  inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

  LDFLAGS = optionalString (!stdenv.isDarwin) "-lgcc_s";
  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-msse2";

  buildInputs = optionals stdenv.isDarwin [ CF configd ];

  patches =
    [ # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
      ./search-path.patch

      # Python recompiles a Python if the mtime stored *in* the
      # pyc/pyo file differs from the mtime of the source file.  This
      # doesn't work in Nix because Nix changes the mtime of files in
      # the Nix store to 1.  So treat that as a special case.
      ./nix-store-mtime.patch

      # patch python to put zero timestamp into pyc
      # if DETERMINISTIC_BUILD env var is set
      ./deterministic-build.patch
    ];

  # Hack hack hack to stop shit from failing from a missing _scproxy on Darwin. Since
  # we only use this python for bootstrappy things, it doesn't really matter if it
  # doesn't have perfect proxy support in urllib :) this just makes it fall back on env
  # vars instead of attempting to read the proxy configuration automatically, so not a
  # huge loss even if for whatever reason we did want proxy support.
  postPatch = ''
    substituteInPlace Lib/urllib.py --replace "if sys.platform == 'darwin'" "if False"
  '';

  DETERMINISTIC_BUILD = 1;

  preConfigure = ''
      # Purity.
      for i in /usr /sw /opt /pkg; do
        substituteInPlace ./setup.py --replace $i /no-such-path
      done
    '' + optionalString (stdenv ? cc && stdenv.cc.libc != null) ''
      for i in Lib/plat-*/regen; do
        substituteInPlace $i --replace /usr/include/ ${stdenv.cc.libc}/include/
      done
    '' + optionalString stdenv.isDarwin ''
      substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
      substituteInPlace Lib/multiprocessing/__init__.py \
        --replace 'os.popen(comm)' 'os.popen("${coreutils}/bin/nproc")'
    '';

  configureFlags = [ "--enable-shared" "--with-threads" "--enable-unicode=ucs4" ]
    ++ optionals stdenv.isCygwin [ "ac_cv_func_bind_textdomain_codeset=yes" ]
    ++ optionals stdenv.isDarwin [ "--disable-toolbox-glue" ];

  postInstall =
    ''
      ln -s $out/share/man/man1/{python2.7.1.gz,python.1.gz}

      rm "$out"/lib/python*/plat-*/regen # refers to glibc.dev
    '';

  enableParallelBuilding = true;

  passthru.pkgs = builtins.throw "python-boot does not support packages, this package is only intended for bootstrapping." {};

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
    license = stdenv.lib.licenses.psfl;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ lnl7 domenkozar ];
  };
}
