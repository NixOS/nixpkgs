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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GZmurg3rpD081QZW/LUKWblhsQQSS6lg9O7y/kGy4To=";
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
    maintainers = [ ];
  };
}
