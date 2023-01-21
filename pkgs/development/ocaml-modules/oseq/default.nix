{ lib, fetchFromGitHub, buildDunePackage
, seq
, containers, qcheck
}:

buildDunePackage rec {
  version = "0.4";
  pname = "oseq";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FoCBvvPwa/dUCrgDEd0clEKAO7EcpedjaO4v+yUO874=";
  };

  propagatedBuildInputs = [ seq ];

  duneVersion = "3";

  doCheck = true;
  nativeCheckInputs = [
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
