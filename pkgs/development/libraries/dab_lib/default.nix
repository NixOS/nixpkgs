{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, faad2, fftwFloat, zlib
}:

stdenv.mkDerivation {
  pname = "dab_lib";
  version = "unstable-2021-12-28";

  src = fetchFromGitHub {
    owner = "JvanKatwijk";
    repo = "dab-cmdline";
    rev = "d23adb3616bb11d98a909aceecb5a3b9507a674c";
    sha256 = "sha256-n/mgsldgXEOLHZEL1cmsqXgFXByWoMeNXNoDWqPpipA=";
  };

  sourceRoot = "source/library/";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ faad2 fftwFloat zlib ];

  meta = with lib; {
    description = "DAB/DAB+ decoding library";
    homepage = "https://github.com/JvanKatwijk/dab-cmdline";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexwinter ];
    platforms = platforms.linux;
  };
}
