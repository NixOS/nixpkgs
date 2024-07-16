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
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "boca";
    rev = "v${version}";
    sha256 = "sha256-HIYUMFj5yiEC+liZLMXD9otPyoEb1sxHlECTYtYXc2I=";
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
    description = "Component library used by the fre:ac audio converter";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/enzo1982/boca";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
