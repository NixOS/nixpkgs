{ lib
, stdenv
, fetchFromGitHub
, pkg-config

, expat
, libcdio
, libcdio-paranoia
, libpulseaudio
, smooth
, uriparser
, zlib
}:

stdenv.mkDerivation rec {
  pname = "BoCA";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "boca";
    rev = "v${version}";
    sha256 = "sha256-ooLPpwTxG7QBAGhEGhta4T06ZDWlPysocHbb/Sq7Wyo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    expat
    libcdio
    libcdio-paranoia
    libpulseaudio
    smooth
    uriparser
    zlib
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "A component library used by the fre:ac audio converter";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/enzo1982/boca";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
