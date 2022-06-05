{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "ldacBT";
  version = "2.0.2.3";

  src = fetchFromGitHub {
    repo = "ldacBT";
    owner = "ehfive";
    rev = "v${version}";
    sha256 = "09dalysx4fgrgpfdm9a51x6slnf4iik1sqba4xjgabpvq91bnb63";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "AOSP libldac dispatcher";
    homepage    = "https://github.com/EHfive/ldacBT";
    license     = licenses.asl20;
    platforms   = platforms.all;
    maintainers = with maintainers; [ adisbladis ];
  };
}
