{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "py-synologydsm-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-L+i6PpN+3CgPp1X/EUQTXz1IUW3S0BJuuPPT4LKBtWs=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "synology_dsm"
  ];

  meta = with lib; {
    description = "Python API for Synology DSM";
    homepage = "https://github.com/mib1185/py-synologydsm-api";
    changelog = "https://github.com/mib1185/py-synologydsm-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
