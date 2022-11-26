{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, coin-utils
}:

stdenv.mkDerivation rec {
  pname = "coin-osi";
  version = "0.108.7";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "osi";
    rev = "52bafbabf8d29bcfd57818f0dd50ee226e01db7f";
    deepClone = true;
    sha256 = "V29t8oPk0u7UFyMu76U4B8YhxLh85PdHj4QDOHXFlm0=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    coin-utils
  ];
}
