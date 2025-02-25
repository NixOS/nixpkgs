{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxslt,
  telepathy-glib,
  python3,
  libxml2,
  dbus-glib,
  dbus,
  sqlite,
  libsoup_2_4,
  libnice,
  gnutls,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "telepathy-gabble";
  version = "0.18.4";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-gabble/telepathy-gabble-${version}.tar.gz";
    sha256 = "174nlkqm055vrhv11gy73m20jbsggcb0ddi51c7s9m3j5ibr2p0i";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-packages/raw/edcf78c831894000f2fbfd3e5818e363911c746a/trunk/telepathy-gabble-0.18.4-python3.patch";
      hash = "sha256-bvcZW6gbCNogqwPDaXHTbohe7c2GAYjXeHGyBEDVsB4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    libxslt
    python3
  ];
  buildInputs = [
    libxml2
    dbus-glib
    sqlite
    libsoup_2_4
    libnice
    telepathy-glib
    gnutls
  ];

  nativeCheckInputs = [ dbus ];

  configureFlags = [ "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt" ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with lib; {
    description = "Jabber/XMPP connection manager for the Telepathy framework";
    mainProgram = "telepathy-gabble-xmpp-console";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-gabble/";
    license = licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
