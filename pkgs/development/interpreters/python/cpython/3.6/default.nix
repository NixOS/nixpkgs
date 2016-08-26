{ stdenv, fetchurl
, glibc
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
, callPackage
, self
, python36Packages

, CF, configd
}:

assert readline != null -> ncurses != null;

with stdenv.lib;

let
  majorVersion = "3.6";
  pythonVersion = majorVersion;
  version = "${majorVersion}.0a3";
  fullVersion = "${version}";

  buildInputs = filter (p: p != null) [
    glibc
    zlib
    bzip2
    lzma
    gdbm
    sqlite
    db
    readline
    ncurses
    openssl
    tcl
    tk
    libX11
    xproto
  ] ++ optionals stdenv.isDarwin [ CF configd ];
in
stdenv.mkDerivation {
  name = "python3-${fullVersion}";
  pythonVersion = majorVersion;
  inherit majorVersion version;

  inherit buildInputs;

  src = fetchurl {
    url = "https://www.python.org/ftp/python/${majorVersion}.0/Python-${fullVersion}.tar.xz";
    sha256 = "08c3598bwihibwca9lwxq923sjq9shvgv3wxv4vkga2n6hf63l1c";
  };

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lgcc_s";

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
    substituteInPlace configure --replace '-Wl,-stack_size,1000000' ' '
  '';

  preConfigure = ''
    for i in /usr /sw /opt /pkg; do	# improve purity
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
    ${optionalString stdenv.isDarwin ''
       export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -msse2"
       export MACOSX_DEPLOYMENT_TARGET=10.6
     ''}

    substituteInPlace ./Lib/plat-generic/regen --replace "/usr/include" ${glibc.dev}/include

    configureFlagsArray=( --enable-shared --with-threads
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
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null) && (libX11 != null) && (xproto != null);
    libPrefix = "python${majorVersion}";
    executable = "python${majorVersion}m";
    buildEnv = callPackage ../../wrapper.nix { python = self; };
    withPackages = import ../../with-packages.nix { inherit buildEnv; pythonPackages = python36Packages; };
    isPy3 = true;
    isPy35 = true;
    is_py3k = true;  # deprecated
    sitePackages = "lib/${libPrefix}/site-packages";
    interpreter = "${self}/bin/${executable}";
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
    license = licenses.psfl;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ chaoflow domenkozar cstrahan kragniz ];
  };
}
