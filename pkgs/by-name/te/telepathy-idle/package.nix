{
  lib,
  stdenv,
  fetchurl,
  glib,
  dconf,
  pkg-config,
  dbus-glib,
  telepathy-glib,
  python3,
  libxslt,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "telepathy-idle";
  version = "0.2.2";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-g4fiXl+wtMvnAeXcCS1mbWUQuDP9Pn5GLpFw027DwV8=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    makeWrapper
  ];
  buildInputs = [
    glib
    telepathy-glib
    dbus-glib
    libxslt
    (lib.getLib dconf)
  ];

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-idle" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  meta = {
    description = "IRC connection manager for the Telepathy framework";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-idle/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
