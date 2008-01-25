args: with args;

stdenv.mkDerivation {
  name = "kdepim-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdepim-4.0.0.tar.bz2;
    sha256 = "kdepim is not included";
  };

  buildInputs = [libXinerama mesa stdenv.gcc.libc alsaLib kdelibs kdepimlibs
  kdeworkspace libusb glib];
  qt4BadIncludes = true;
  inherit qt kdelibs;
}
