args: with args;

stdenv.mkDerivation {
  name = "kdepim-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdepim-3.95.0.tar.bz2;
    sha256 = "0gzvm4h6ij7i119apmh9w82raygahr18bl0i9m3ynf2mcca0aq94";
  };

  buildInputs = [libXinerama mesa stdenv.gcc.libc alsaLib kdelibs kdepimlibs
  kdeworkspace libusb glib];
  qt4BadIncludes = true;
  inherit qt kdelibs;
}
