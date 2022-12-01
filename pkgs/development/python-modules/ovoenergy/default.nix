{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ovoenergy";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OSK74uvpHuEtWgbLVFrz1NO7lvtHbt690smGQ+GlsOI=";
  };

  propagatedBuildInputs = [
    aiohttp
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ovoenergy"
  ];

  meta = with lib; {
    description = "Python client for getting data from OVO's API";
    homepage = "https://github.com/timmo001/ovoenergy";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
