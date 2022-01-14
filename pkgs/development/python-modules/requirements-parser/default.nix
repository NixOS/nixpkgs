{ lib
, buildPythonPackage
, fetchPypi
, nose
}:
buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3852277618e653dd1d8fa4129e59b4338358dffafeb3d5106e9f88504db9c460";
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
