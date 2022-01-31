{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, python-slugify
, pythonOlder
, voluptuous
, websocket-client
, xmltodict
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "0.28.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-zYSJMP/uwgyIHdI8E7NHLaHrpAQeLpaEcXXXlzIO5ns=";
  };

  propagatedBuildInputs = [
    aiohttp
    python-slugify
    voluptuous
  ];

  checkInputs = [
    pydevccu
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hahomematic"
  ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
