{ lib, buildDunePackage, fetchFromGitHub, zarith, digestif, fmt }:

buildDunePackage rec {
  pname = "tezos-base58";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tarides";
    repo = pname;
    rev = version;
    sha256 = "sha256-0qR/J0oIzCSyBr0nwVJR6Yg66OO6DJtCVwJ/IC+dQyM=";
  };

  propagatedBuildInputs = [ zarith digestif fmt ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/tarides/tezos-base58";
    description = "Base58 encoding for Tezos";
    license = licenses.mit;
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
