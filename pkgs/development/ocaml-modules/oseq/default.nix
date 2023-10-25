{ lib, fetchFromGitHub, buildDunePackage
, containers, qcheck
}:

buildDunePackage rec {
  version = "0.5";
  pname = "oseq";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JMIcRyciNvLOE1Gpin7CpcDNSmGYFxZWsDN0X6D/NVI=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  doCheck = true;
  checkInputs = [
    containers
    qcheck
  ];

  meta = {
    homepage = "https://c-cube.github.io/oseq/";
    description = "Purely functional iterators compatible with standard `seq`";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
