{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, urllib3
}:

buildPythonPackage rec {
  pname = "freebox-api";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3i9I2RRRxLgyfzegnqjO4g+ad1v4phx6xa8HpWP1cck=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "urllib3"
  ];

  propagatedBuildInputs = [
    aiohttp
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "freebox_api"
  ];

  meta = with lib; {
    description = "Python module to interact with the Freebox OS API";
    homepage = "https://github.com/hacf-fr/freebox-api";
    changelog = "https://github.com/hacf-fr/freebox-api/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
