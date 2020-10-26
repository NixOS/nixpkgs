{ lib
, buildPythonPackage
, maturin
, fetchFromGitHub
, wheel
, toml
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = pname;
    rev = version;
    sha256 = "2+CZ4K4Sijt3ksjD6pVteRNNf+4z0iwZQon11b0+nyk=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    maturin
    wheel
    toml
  ];

  meta = {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    license = with lib.licenses; [ 
      asl20
      mit
    ];
    homepage = "https://github.com/ijl/orjson";
    broken = true; # Requires rust nightly
  };

}