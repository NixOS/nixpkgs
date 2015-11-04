{ lib, stdenv, fetchurl, pkgconfig, udev, glib }:

let version = "230"; in

stdenv.mkDerivation rec {
  name = "libgudev-${version}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgudev/${version}/${name}.tar.xz";
    sha256 = "a2e77faced0c66d7498403adefcc0707105e03db71a2b2abd620025b86347c18";
  };

  buildInputs = [ pkgconfig udev glib ];

  meta = {
    homepage = https://wiki.gnome.org/Projects/libgudev;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2Plus;
  };
}
