{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2022.06.15";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-certifi";
    rev = version;
    sha256 = "sha256-CKO8wF5FMGLIZbTd7YrKE9OWV9MbfQ2+BMc5IPk1FFU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "certifi" ];

  meta = with lib; {
    homepage = "https://github.com/certifi/python-certifi";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
    maintainers = with maintainers; [ koral SuperSandro2000 ];
  };
}
