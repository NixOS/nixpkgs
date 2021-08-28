{ lib
, buildPythonPackage
, fetchPypi
, nose
}:
buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5963ee895c2d05ae9f58d3fc641082fb38021618979d6a152b6b1398bd7d4ed4";
  };

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "requirements"
  ];

  meta = with lib; {
    description = "A Pip requirements file parser";
    homepage = "https://github.com/davidfischer/requirements-parser";
    license = licenses.bsd2;
    maintainers = teams.determinatesystems.members;
  };
}
