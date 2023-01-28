{ lib
, fetchPypi
, buildPythonPackage
, normality
, mypy
, coverage
, nose
}:
buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cafd5f92b5b91e4ce34af2b954da9c05b448a4778947785abb19a14f363352d0";
  };

  propagatedBuildInputs = [
    normality
  ];

  nativeCheckInputs = [
    mypy
    coverage
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "fingerprints"
  ];

  meta = with lib; {
    description = "A library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
