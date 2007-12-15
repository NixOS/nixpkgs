args: with args;

stdenv.mkDerivation {
  name = "kdepim-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdepim-3.97.0.tar.bz2;
    sha256 = "1x5ywn1z963azrrm6rlsspzlsbbwxcsb3zc93pdy80qq1jwsf964";
  };

  buildInputs = [libXinerama mesa stdenv.gcc.libc alsaLib kdelibs kdepimlibs
  kdeworkspace libusb glib];
  qt4BadIncludes = true;
  inherit qt kdelibs;
}
