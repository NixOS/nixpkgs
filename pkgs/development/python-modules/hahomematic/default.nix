{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools
, voluptuous
, websocket-client
, xmltodict
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "2022.11.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-m28UDaBk2EFwulkjvuT6zpLEeVL/oofHUVSop+AKYvc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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

  # Starting with 0.30 the tests are broken, check with the next major release
  doCheck = false;

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
