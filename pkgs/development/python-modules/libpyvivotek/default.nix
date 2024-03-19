{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, vcrpy
}:

buildPythonPackage rec {
  pname = "libpyvivotek";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HarlemSquirrel";
    repo = "python-vivotek";
    rev = "v${version}";
    sha256 = "pNlnGpDjdYE7Lxog8GGZV+UZZmfmt5bwHof5LngPQjg=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [
    "libpyvivotek"
  ];

  meta = with lib; {
    description = "Python Library for Vivotek IP Cameras";
    homepage = "https://github.com/HarlemSquirrel/python-vivotek";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
