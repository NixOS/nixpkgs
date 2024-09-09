{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "maxflow";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "gerddie";
    repo = pname;
    rev = version;
    hash = "sha256-a84SxGMnfBEaoMEeeIFffTOtErSN5yzZBrAUDjkalGY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Software for computing mincut/maxflow in a graph";
    homepage = "https://github.com/gerddie/maxflow";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.tadfisher ];
  };
}
