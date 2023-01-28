{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
}:

stdenv.mkDerivation rec {
  pname = "quantlib";
  version = "1.29";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "lballabio";
    repo = "QuantLib";
    rev = "QuantLib-v${version}";
    sha256 = "sha256-TpVn3zPru/GtdNqDH45YdOkm7fkJzv/qay9SY3J6Jiw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  meta = with lib; {
    description = "A free/open-source library for quantitative finance";
    homepage = "https://quantlib.org";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
