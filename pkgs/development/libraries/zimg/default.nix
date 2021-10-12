{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "zimg";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner  = "sekrit-twc";
    repo   = "zimg";
    rev    = "release-${version}";
    sha256 = "0pwgf1mybpa3fs13p6jryzm32vfldyql9biwaypqdcimlnlmyk20";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage    = "https://github.com/sekrit-twc/zimg";
    license     = licenses.wtfpl;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
