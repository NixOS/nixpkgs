{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2
, darwinArchUtility ? null, darwinSwVersUtility ? null
}:

assert zlibSupport -> zlib != null;
assert stdenv.isDarwin -> darwinArchUtility != null;
assert stdenv.isDarwin -> darwinSwVersUtility != null;

with stdenv.lib;

let

  majorVersion = "2.7";
  version = "${majorVersion}.1";

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [ bzip2 ]
    ++ optional zlibSupport zlib
    ++ optionals stdenv.isDarwin [ darwinArchUtility darwinSwVersUtility ];

in

stdenv.mkDerivation {
  name = "python-${version}";
  inherit majorVersion version;

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.bz2";
    sha256 = "14i2c7yqa7ljmx2i2bb827n61q33zn23ax96czi8rbkyyny8gqw0";
  };

  patches =
    [ # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
      ./search-path.patch

      # Python recompiles a Python if the mtime stored *in* the
      # pyc/pyo file differs from the mtime of the source file.  This
      # doesn't work in Nix because Nix changes the mtime of files in
      # the Nix store to 1.  So treat that as a special case.
      ./nix-store-mtime.patch
    ];

  inherit buildInputs;
  
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  
  configureFlags = "--enable-shared --with-threads --enable-unicode --with-wctype-functions";

  preConfigure =
    ''
      # Purity.
      for i in /usr /sw /opt /pkg; do
        substituteInPlace ./setup.py --replace $i /no-such-path
      done
    '';

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-msse2";

  setupHook = ./setup-hook.sh;

  postInstall =
    ''
      rm -rf "$out/lib/python${majorVersion}/test"
    '';

  passthru = {
    inherit zlibSupport;
    libPrefix = "python${majorVersion}";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "http://python.org";
    description = "Python -- a high-level dynamically-typed programming language";
    longDescription = ''
      Python is a remarkably powerful dynamic programming language that
      is used in a wide variety of application domains. Some of its key
      distinguishing features include: clear, readable syntax; strong
      introspection capabilities; intuitive object orientation; natural
      expression of procedural code; full modularity, supporting
      hierarchical packages; exception-based error handling; and very
      high level dynamic data types.
    '';
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
