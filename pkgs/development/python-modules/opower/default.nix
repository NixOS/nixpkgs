{ lib
, aiohttp
, arrow
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
}:

buildPythonPackage rec {
  pname = "opower";
  version = "0.0.20";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "opower";
    rev = "refs/tags/v${version}";
    hash = "sha256-hb+TVnCAAnsoKPk9N1bDXj463CErp7nn2cteOumKhLs=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
