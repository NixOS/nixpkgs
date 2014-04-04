{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation {
  name = "libdvdread-4.2.1";
  
  src = fetchurl {
    url = http://dvdnav.mplayerhq.hu/releases/libdvdread-4.2.1.tar.xz;
    sha256 = "af9b98f049580a6521d56c978b736d3d609562dd12955e11d50e26d97542dcd4";
  };

  buildInputs = [libdvdcss];

  NIX_LDFLAGS = "-ldvdcss";

  configureScript = "./configure2"; # wtf?

  preConfigure = ''
    mkdir -p $out
  '';

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = http://www.mplayerhq.hu/;
    description = "A library for reading DVDs";
  };
}
