{ stdenv, fetchurl
, zlib
, bzip2
, gdbm
, sqlite
, db4
, ncurses
, readline
, openssl
, tcl, tk
, libX11, xproto
}:

assert readline != null -> ncurses != null;

with stdenv.lib;

let
  majorVersion = "3.1";
  version = "${majorVersion}.3";

  buildInputs = filter (p: p != null) [
    zlib bzip2 gdbm sqlite db4 readline ncurses openssl tcl tk libX11 xproto
  ];
in
stdenv.mkDerivation {
  name = "python3-${version}";
  inherit majorVersion version;

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.bz2";
    sha256 = "1jsqapgwrcqcaskyi2qdn1xj7l8x5340a137hdfshk5ya4dg9xkp";
  };

  inherit buildInputs;
  patches = [ ./search-path.patch ];

  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  configureFlags = "--enable-shared --with-threads --enable-unicode --with-wctype-functions";

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString (ncurses != null) ''export NIX_LDFLAGS="$NIX_LDFLAGS -lncurses"''}
    ${optionalString stdenv.isDarwin   ''export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"''}
  '';

  setupHook = ./setup-hook.sh;

  postInstall = ''
    rm -rf "$out/lib/python${majorVersion}/test"
  '';

  passthru = {
    zlibSupport = zlib != null;
    sqliteSupport = sqlite != null;
    db4Support = db4 != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null);
    libPrefix = "python${majorVersion}";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "http://python.org";
    description = "a high-level dynamically-typed programming language";
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
    maintainers = with stdenv.lib.maintainers; [ simons chaoflow ];
  };

}
