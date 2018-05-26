{ stdenv, fetchurl, pkgconfig, telepathy-glib, farstream, dbus-glib }:

stdenv.mkDerivation rec {
  name = "${pname}-0.6.2";
  pname = "telepathy-farstream";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "02ky12bb92prr5f6xmvmfq4yz2lj33li6nj4829a98hk5pr9k83g";
  };

  propagatedBuildInputs = [ dbus-glib telepathy-glib farstream ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
