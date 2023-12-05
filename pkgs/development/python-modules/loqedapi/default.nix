{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "loqedapi";
  version = "2.1.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cpolhout";
    repo = "loqedAPI";
    rev = "refs/tags/v${version}";
    hash = "sha256-9ekZ98GazH1tna4JT5SEUETKR227UYRIBBghdj+TFB4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "loqedAPI"
  ];

  meta = with lib; {
    description = "Module to interact with the Loqed Smart Door Lock API";
    homepage = "https://github.com/cpolhout/loqedAPI";
    changelog = "https://github.com/cpolhout/loqedAPI/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
