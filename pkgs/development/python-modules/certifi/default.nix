{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2022.09.24";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-certifi";
    rev = version;
    hash = "sha256-B6LO6AfG9cfpyNI7hj3VjmGTFsrrIkDYO4gPMkZY74w=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "certifi"
  ];

  meta = with lib; {
    homepage = "https://github.com/certifi/python-certifi";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
    maintainers = with maintainers; [ koral SuperSandro2000 ];
  };
}
