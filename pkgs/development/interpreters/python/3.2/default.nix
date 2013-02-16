{ stdenv, fetchurl
, bzip2
, db4
, gdbm
, libX11, xproto
, ncurses
, openssl
, readline
, sqlite
, tcl, tk
, zlib
}:

assert readline != null -> ncurses != null;

with stdenv.lib;

let
  majorVersion = "3.2";
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
    sha256 = "5648ec81f93870fde2f0aa4ed45c8718692b15ce6fd9ed309bfb827ae12010aa";
  };

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"''}

    configureFlagsArray=( --enable-shared --with-threads
                          CPPFLAGS="${concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
                          LDFLAGS="${concatStringsSep " " (map (p: "-L${p}/lib") buildInputs)}"
                          LIBS="-lcrypt ${optionalString (ncurses != null) "-lncurses"}"
                        )
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
    tkSupport = (tk != null) && (tcl != null) && (libX11 != null) && (xproto != null);
    libPrefix = "python${majorVersion}m";
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
