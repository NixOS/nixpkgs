{ stdenv, fetchurl
, bzip2
, db
, gdbm
, libX11, xproto
, lzma
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
  majorVersion = "3.4";
  version = "${majorVersion}.1";
  fullVersion = "${version}";

  buildInputs = filter (p: p != null) [
    zlib bzip2 lzma gdbm sqlite db readline ncurses openssl tcl tk libX11 xproto
  ];
in
stdenv.mkDerivation {
  name = "python3-${fullVersion}";
  inherit majorVersion version;

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${fullVersion}.tar.xz";
    sha256 = "1i7dgbzyvj24i6gfhb5q2zwr9nn1ni6w1ig1rcgh96a321is35f5";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"''}

    configureFlagsArray=( --enable-shared --with-threads
                          CPPFLAGS="${concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
                          LDFLAGS="${concatStringsSep " " (map (p: "-L${p}/lib") buildInputs)}"
                          LIBS="${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}"
                        )
  '';

  setupHook = ./setup-hook.sh;

  postInstall = ''
    rm -rf "$out/lib/python${majorVersion}/test"
    ln -s "$out/include/python${majorVersion}m" "$out/include/python${majorVersion}"

    paxmark E $out/bin/python${majorVersion}
  '';

  passthru = rec {
    zlibSupport = zlib != null;
    sqliteSupport = sqlite != null;
    dbSupport = db != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null) && (libX11 != null) && (xproto != null);
    libPrefix = "python${majorVersion}";
    executable = "python3.4m";
    isPy3 = true;
    isPy34 = true;
    is_py3k = true;  # deprecated
    sitePackages = "lib/${libPrefix}/site-packages";
  };

  enableParallelBuilding = true;

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
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ simons chaoflow iElectric cstrahan ];
  };
}
