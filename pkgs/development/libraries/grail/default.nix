{ enableX11 ? true,
  stdenv, fetchurl, pkgconfig, xorg, python3, frame }:

stdenv.mkDerivation rec {
  name = "grail-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "https://launchpad.net/grail/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "c26dced1b3f4317ecf6af36db0e90294d87e43966d56aecc4e97b65368ab78b9";
  };

  buildInputs = [ pkgconfig python3 frame ]
  ++ stdenv.lib.optionals enableX11 [xorg.libX11 xorg.libXtst xorg.libXext xorg.libXi xorg.libXfixes];

  configureFlags = stdenv.lib.optional enableX11 "--with-x11";

  meta = {
    homepage = "https://launchpad.net/canonical-multitouch/grail";
    description = "Gesture Recognition And Instantiation Library";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
