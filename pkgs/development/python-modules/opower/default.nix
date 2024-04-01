{ lib
, aiohttp
, arrow
, buildPythonPackage
, fetchFromGitHub
, pyotp
, pytestCheckHook
, python-dotenv
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "opower";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "opower";
    rev = "refs/tags/v${version}";
    hash = "sha256-mQE3WypB//OPilx4vA8b8V+eO0MJ/cSa3wILLW+Jk4Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    arrow
    pyotp
    python-dotenv
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "opower"
  ];

  meta = with lib; {
    description = "Module for getting historical and forecasted usage/cost from utilities that use opower.com";
    homepage = "https://github.com/tronikos/opower";
    changelog = "https://github.com/tronikos/opower/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
