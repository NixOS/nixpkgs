{ stdenv, fetchurl
, bzip2
, db
, gdbm
, libX11, xproto
, ncurses
, openssl
, readline
, sqlite
, tcl, tk
, zlib
, callPackage
, self
}:

assert readline != null -> ncurses != null;

with stdenv.lib;

let
  majorVersion = "3.2";
  version = "${majorVersion}.6";

  buildInputs = filter (p: p != null) [
    zlib bzip2 gdbm sqlite db readline ncurses openssl tcl tk libX11 xproto
  ];
in
stdenv.mkDerivation {
  name = "python3-${version}";
  pythonVersion = majorVersion;
  inherit majorVersion version;

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
    sha256 = "1p3vvvh3qw8avq959hdl6bq5d6r7mbhrnigqzgx6mllzh40va4hx";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"''}

    configureFlagsArray=( --enable-shared --with-threads --with-wide-unicode
                          CPPFLAGS="${concatStringsSep " " (map (p: "-I${getDev p}/include") buildInputs)}"
                          LDFLAGS="${concatStringsSep " " (map (p: "-L${getLib p}/lib") buildInputs)}"
                          LIBS="${optionalString (!stdenv.isDarwin) "-lcrypt"} ${optionalString (ncurses != null) "-lncurses"}"
                        )
  '';

  setupHook = ./setup-hook.sh;

  postInstall = ''
    # needed for some packages, especially packages that backport functionality
    # to 2.x from 3.x
    for item in $out/lib/python${majorVersion}/test/*; do
      if [[ "$item" != */test_support.py* ]]; then
        rm -rf "$item"
      else
        echo $item
      fi
    done
    touch $out/lib/python${majorVersion}/test/__init__.py
    ln -s "$out/include/python${majorVersion}m" "$out/include/python${majorVersion}"
    paxmark E $out/bin/python${majorVersion}
  '';

  passthru = rec {
    zlibSupport = zlib != null;
    sqliteSupport = sqlite != null;
    dbSupport = db != null;
    buildEnv = callPackage ../wrapper.nix { python = self; };
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null) && (libX11 != null) && (xproto != null);
    libPrefix = "python${majorVersion}";
    executable = "python3.2m";
    isPy3 = true;
    isPy32 = true;
    is_py3k = true;  # deprecated
    sitePackages = "lib/${libPrefix}/site-packages";
    interpreter = "${self}/bin/${executable}";
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
    maintainers = with stdenv.lib.maintainers; [ simons chaoflow cstrahan ];
  };
}
