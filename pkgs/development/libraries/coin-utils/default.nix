{ stdenv
, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation rec {
  pname = "coin-utils";
  version = "2.11.6";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "CoinUtils";
    rev = "b29532e31471d26dddee99095da3340e80e8c60c";
    deepClone = true;
    sha256 = "hJtWLNf8QWCBn7td8GtZpIejMrxiWy/L/TVFQKHAotg=";
  };
  nativeBuildInputs = [
    cmake
  ];
}
