{ stdenv, fetchurl, libXi, libXrandr, libXxf86vm, mesa, x11 }:

stdenv.mkDerivation {
  name = "freeglut-2.8.1";

  src = fetchurl {
    url = mirror://sourceforge/freeglut/freeglut-2.8.1.tar.gz;
    sha256 = "16lrxxxd9ps9l69y3zsw6iy0drwjsp6m26d1937xj71alqk6dr6x";
  };

  configureFlags = "--" + (if stdenv.isDarwin then "disable" else "enable") + "-warnings";

  buildInputs = [ libXi libXrandr libXxf86vm mesa x11 ];
  # patches = [ ./0001-remove-typedefs-now-living-in-mesa.patch ];
}
