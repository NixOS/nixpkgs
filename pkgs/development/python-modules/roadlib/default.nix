{ lib
, adal
, buildPythonPackage
, fetchPypi
, pyjwt
, pythonOlder
, setuptools
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "roadlib";
  version = "0.23.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0hDiuF0dBRyR2B9dp4c7/jsC6li8uOduQBbhs6fFLfU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    adal
    pyjwt
    sqlalchemy
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "roadtools.roadlib"
  ];

  meta = with lib; {
    description = "ROADtools common components library";
    homepage = "https://pypi.org/project/roadlib/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
