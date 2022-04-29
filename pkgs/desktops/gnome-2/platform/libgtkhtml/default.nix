{ lib, stdenv, fetchurl, pkg-config, gtk2, gettext, libxml2 }:

stdenv.mkDerivation rec {
  pname = "libgtkhtml";
  version = "2.11.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgtkhtml/${lib.versions.majorMinor version}/libgtkhtml-${version}.tar.bz2";
    sha256 = "0msajafd42545dxzyr5zqka990cjrxw2yz09ajv4zs8m1w6pm9rw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 gettext ];
  propagatedBuildInputs = [ libxml2 ];

  hardeningDisable = [ "format" ];
}
