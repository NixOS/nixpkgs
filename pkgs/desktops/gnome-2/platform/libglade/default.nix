{ lib, stdenv, fetchurl, pkg-config, gtk2, libxml2, gettext }:

stdenv.mkDerivation rec {
  pname = "libglade";
  version = "2.6.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libglade/${lib.versions.majorMinor version}/libglade-${version}.tar.bz2";
    sha256 = "1v2x2s04jry4gpabws92i0wq2ghd47yr5n9nhgnkd7c38xv1wdk4";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 gettext ];

  NIX_LDFLAGS = "-lgmodule-2.0";

  propagatedBuildInputs = [ libxml2 ];
}
