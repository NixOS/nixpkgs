{ stdenv, fetchurl, pkgconfig, glib }:

let
  version = "0.1.0";
in stdenv.mkDerivation rec {
  name = "xdg-dbus-proxy-${version}";

  src = fetchurl {
    url = "https://github.com/flatpak/xdg-dbus-proxy/releases/download/${version}/${name}.tar.xz";
    sha256 = "055wli36lvdannp6qqwbvd78353n61wn9kp8y3dchh39wq7x7vwy";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "DBus proxy for Flatpak and others";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
