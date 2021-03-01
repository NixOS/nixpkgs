{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flametree";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8eb81dea8c7f8261a2aa03d2bac98b1d21ebceec9c67efaac423f7c1b4fe061";
  };

  # no tests in tarball
  doCheck = false;

  pythonImportsCheck = [ "flametree" ];

  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/Flametree";
    description = "Python file and zip operations made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
