{ stdenv, fetchurl, libXi, libXrandr, libXxf86vm, mesa, x11 }:

stdenv.mkDerivation {
  name = "freeglut-2.8.0";

  src = fetchurl {
    url = mirror://sourceforge/freeglut/freeglut-2.8.0.tar.gz;
    sha256 = "197293ff886abe613bc9eb4a762d9161b0c9e64b3e8e613ed7c5e353974fba05";
  };

  configureFlags = "--" + (if stdenv.isDarwin then "disable" else "enable") + "-warnings";

  buildInputs = [ libXi libXrandr libXxf86vm mesa x11 ];
  patches = [ ./0001-remove-typedefs-now-living-in-mesa.patch ];
}
