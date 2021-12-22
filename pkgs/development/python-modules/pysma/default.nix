{ lib
, aiohttp
, aioresponses
, attrs
, buildPythonPackage
, fetchFromGitHub
, jmespath
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysma";
  version = "0.6.10";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kellerza";
    repo = pname;
    rev = version;
    sha256 = "sha256-HSezbwJg6uPy7JFflRUlaHQw5KWLEmRMgOzbP2NKGik=";
  };
  propagatedBuildInputs = [
    aiohttp
    attrs
    jmespath
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysma"
  ];

  meta = with lib; {
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
