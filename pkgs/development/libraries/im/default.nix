{ lib
, stdenv
, fetchurl

, lsb-release
, which
, pkg-config
, gtk3
, fontconfig
, ftgl
, libGLU
, fftw
, fftwFloat
, lua
}:

stdenv.mkDerivation rec {
  pname = "im";
  version = "3.15";

  src = fetchurl {
    url = "mirror://sourceforge/imtoolkit/${version}/Docs%20and%20Sources/${pname}-${version}_Sources.tar.gz";
    sha256 = "sha256-NsxCV/j1+BEouFS7O+KcXL3QkUdlKPMVr2ZtCTC5tX4=";
  };

  buildInputs = [
    lsb-release
    which
    pkg-config
    gtk3
    fontconfig
    ftgl
    libGLU
    fftw
    fftwFloat
    lua
  ];

  sourceRoot = "im/src";

  installPhase = ''
    install -m755 -d "$out/lib"
    install -m644 ../lib/*/lib*.so "$out/lib"
    install -m755 -d "$out/include"
    install -m644 ../include/* "$out/include"
  '';

  meta = {
    description = "Toolkit for Digital Imaging";
    homepage = "http://www.tecgraf.puc-rio.br/im/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.linux;
  };
}
