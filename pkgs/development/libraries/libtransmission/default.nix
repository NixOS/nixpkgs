{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, curl
, libevent
, inotify-tools
, systemd
, zlib
, pcre
, enableSystemd ? stdenv.isLinux
}:

stdenv.mkDerivation {
  pname = "libtransmission";
  version = "3.00";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = version;
    sha256 = "0ccg0km54f700x9p0jsnncnwvfnxfnxf7kcm7pcx1cj0vw78924z";
    fetchSubmodules = true;
  };

  cmakeFlags =
    let
      mkFlag = opt: if opt then "ON" else "OFF";
    in
    [
      "-DENABLE_MAC=OFF" # requires xcodebuild
      "-DENABLE_DAEMON=OFF"
      "-DENABLE_CLI=OFF"
      "-DINSTALL_LIB=ON"
    ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    curl
    libevent
    zlib
    pcre
  ] ++ lib.optionals enableSystemd [ systemd ]
  ++ lib.optionals stdenv.isLinux [ inotify-tools ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreFoundation";

  installFlags = [ "-C" "libtransmission" ];

  meta = with lib; {
    description = "A fast, easy and free BitTorrent client";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
      Feature spotlight:
        * Uses fewer resources than other clients
        * Native Mac, GTK and Qt GUI clients
        * Daemon ideal for servers, embedded systems, and headless use
        * All these can be remote controlled by Web and Terminal clients
        * Bluetack (PeerGuardian) blocklists with automatic updates
        * Full encryption, DHT, and PEX support
    '';
    homepage = "http://www.transmissionbt.com/";
    license = with licenses; [ gpl2Only mit ];
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ onny ];
  };
}

