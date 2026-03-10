{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  telepathy-glib,
  farstream,
  dbus-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "telepathy-farstream";
  version = "0.6.2";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-farstream/telepathy-farstream-${finalAttrs.version}.tar.gz";
    sha256 = "02ky12bb92prr5f6xmvmfq4yz2lj33li6nj4829a98hk5pr9k83g";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    dbus-glib
    telepathy-glib
    farstream
  ];

  meta = {
    description = "GObject-based C library that uses Telepathy GLib, Farstream and GStreamer to handle the media streaming part of channels of type Call";
    homepage = "https://telepathy.freedesktop.org/wiki/Components/Telepathy-Farstream/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Only;
  };
})
