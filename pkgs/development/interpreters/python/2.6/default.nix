{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2
, gdbmSupport ? true, gdbm ? null
, sqlite ? null
, db4 ? null
, readline ? null
, openssl ? null
, tk ? null
, tcl ? null
, libX11 ? null
, xproto ? null
, arch ? null
}:

assert zlibSupport -> zlib != null;
assert gdbmSupport -> gdbm != null;
assert stdenv.isDarwin -> arch != null;

with stdenv.lib;

let

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [bzip2]
    ++ optional zlibSupport zlib
    ++ optional gdbmSupport gdbm
    ++ optional (sqlite != null) sqlite
    ++ optional (db4 != null) db4
    ++ optional (readline != null) readline
    ++ optional (openssl != null) openssl
    ++ optional (tk != null) tk
    ++ optional (tcl != null) tcl
    ++ optional (libX11 != null) libX11
    ++ optional (xproto != null) xproto
    ++ optional (arch != null) arch
    ;

in

stdenv.mkDerivation ( {
  name = "python-2.6.3";

  src = fetchurl {
    url = http://www.python.org/ftp/python/2.6.3/Python-2.6.3.tar.bz2;
    sha256 = "096wxhibhss3clgcj5n3xx5wmdsqmywk3h3bp68sicp7sy4y6rs3";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];

  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  configureFlags = ''${if stdenv.isDarwin then "" else " --enable-shared"} --with-wctype-functions'';

  preConfigure = ''
    # Purity.
    for i in /usr /sw /opt /pkg; do
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  '' + (if readline != null then ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lncurses"
  '' else "");

  setupHook = ./setup-hook.sh;

  postInstall = ''
    rm -rf $out/lib/python2.6/test
  '';

  passthru = {
    inherit zlibSupport;
    sqliteSupport = sqlite != null;
    db4Support = db4 != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null);
    libPrefix = "python2.6";
  };

  meta = {
    # List of supported platforms.
    #  - On Darwin, `python.exe' fails with "Bus Error".
    # platforms = stdenv.lib.platforms.allBut "i686-darwin";
    # Re-enabled for 2.6 to see whether the problem still occurs.
  };
} // (if stdenv.system == "i686-darwin" then { NIX_CFLAGS_COMPILE = "-msse2" ; patches = [./search-path.patch]; } else {} ) )
