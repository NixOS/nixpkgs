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
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "boca";
    rev = "v${version}";
    sha256 = "0x6pqd5cdag0l283lkq01qaqwyf1skxbncdwig8b2s742nbzjlz8";
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
