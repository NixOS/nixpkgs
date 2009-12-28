{stdenv, fetchurl, libnice, pkgconfig, python, glib, gstreamer, gstPluginsBase}:

stdenv.mkDerivation {
  name = "farsight2-0.0.16";
  
  src = fetchurl {
    url = http://farsight.freedesktop.org/releases/farsight2/farsight2-0.0.16.tar.gz;
    sha256 = "07yjndkx1p7ij1ifxsnbqbr8943wmq768x4812khka7dx6ii1sv9";
  };

  buildInputs = [ libnice pkgconfig python glib gstreamer gstPluginsBase ];

  configureFlags = "--disable-python";

  patches = [./makefile.patch];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
  };
}
