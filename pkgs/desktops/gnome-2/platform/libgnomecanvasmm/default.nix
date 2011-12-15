{ stdenv, fetchurl, pkgconfig, libgnomecanvas, gtkmm }:

stdenv.mkDerivation {
  name = "libgnomecanvasmm-2.26.0";

  src = fetchurl {
    url = mirror://gnome/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2;
    sha256 = "996577f97f459a574919e15ba7fee6af8cda38a87a98289e9a4f54752d83e918";
  };

  buildInputs = [ pkgconfig libgnomecanvas gtkmm ];
}
