{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation {
  name = "libdvdread-4.1.3";
  
  src = fetchurl {
    url = http://www.mplayerhq.hu/MPlayer/releases/dvdnav/libdvdread-4.1.3.tar.bz2;
    sha1 = "fc4c7ba3e49929191e057b435bc4f867583ea8d5";
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
