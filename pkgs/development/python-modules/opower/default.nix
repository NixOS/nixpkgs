{ lib
, aiohttp
, arrow
, buildPythonPackage
, fetchFromGitHub
, pyotp
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
}:

buildPythonPackage rec {
  pname = "opower";
  version = "0.0.39";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "opower";
    rev = "refs/tags/v${version}";
    hash = "sha256-5JcediHl2TeMhYa6OJqoW5K0SlAjdIrMwj2IHh3qW7I=";
  };

  pythonRemoveDeps = [
    # https://github.com/tronikos/opower/pull/4
    "asyncio"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    arrow
    pyotp
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
