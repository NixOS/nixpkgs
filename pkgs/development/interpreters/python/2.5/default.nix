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
, ncurses ? null
}:

assert zlibSupport -> zlib != null;
assert gdbmSupport -> gdbm != null;

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
    ++ optional (xproto != null) xproto
    ++ optional (ncurses != null) ncurses
    ;

in

stdenv.mkDerivation ( {
  name = "python-2.5.4";
  majorVersion = "2.5";
  version = "2.5.4";

  src = fetchurl {
    url = http://www.python.org/ftp/python/2.5.4/Python-2.5.4.tar.bz2;
    sha256 = "0401g346ixng1im6gp11rgkfhx3v05qrpn5qjfx26mgy5dm8k3dw";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];

  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  configureFlags = "--enable-shared --with-wctype-functions";

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
    rm -rf $out/lib/python2.5/test
  '';

  passthru = {
    inherit zlibSupport;
    sqliteSupport = sqlite != null;
    db4Support = db4 != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null);
    libPrefix = "python2.5";
  };

  meta = {
    # List of supported platforms.
    #  - On Darwin, `python.exe' fails with "Bus Error".
    platforms = stdenv.lib.platforms.allBut "i686-darwin";
  };
} // (if stdenv.isDarwin then { NIX_CFLAGS_COMPILE = "-msse2" ; patches = [./search-path.patch ./nolongdouble.patch]; } else {} ) )
