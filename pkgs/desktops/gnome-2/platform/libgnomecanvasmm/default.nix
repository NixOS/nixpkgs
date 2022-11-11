{ lib, stdenv, fetchurl, pkg-config, libgnomecanvas, gtkmm2 }:

stdenv.mkDerivation rec {
  pname = "libgnomecanvasmm";
  version = "2.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomecanvasmm/${lib.versions.majorMinor version}/libgnomecanvasmm-${version}.tar.bz2";
    sha256 = "996577f97f459a574919e15ba7fee6af8cda38a87a98289e9a4f54752d83e918";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgnomecanvas gtkmm2 ];
}
