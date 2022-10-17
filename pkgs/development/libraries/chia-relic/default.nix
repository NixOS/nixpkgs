{ lib
, fetchFromGitHub
, stdenv
, cmake, gmp
, substituteAll
}:

stdenv.mkDerivation {
  pname = "relic";
  version = "0.5.0";



  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "relic";
    rev = "215c69966cb78b255995f0ee9c86bbbb41c3c42b";
    sha256 = "sha256-wivK18Cp7BMZJvrYxJgSHInRZgFgsgSzd0YIy5IWoYA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake gmp ];

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DARITH=gmp"
  ];

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/relic";
    description = "RELIC is a modern research-oriented cryptographic meta-toolkit with emphasis on efficiency and flexibility. RELIC can be used to build efficient and usable cryptographic toolkits tailored for specific security levels and algorithmic choices.";
    license = [licenses.asl20 licenses.lgpl21Only];
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
