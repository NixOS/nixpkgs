{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  json-timeseries,
  numpy,
  pandas,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage {
  pname = "openplantbook-sdk";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slaxor505";
    repo = "openplantbook-sdk-py";
    rev = "097ccfbd5cee6a271c79c923f1761249eca4bda1";
    hash = "sha256-udzm8Efl3QX2jrvfzA/oCvk2kjQEFFOZCOFqKNzUUu8=";
  };

  patches = [
    # https://github.com/slaxor505/openplantbook-sdk-py/pull/2
    ./update-test.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    json-timeseries
  ];

  nativeBuildInputs = [
    numpy
    pandas
    pyyaml
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/offline"
  ];

  meta = {
    description = "SDK to integrate with Open Plantbook API";
    homepage = "https://github.com/slaxor505/openplantbook-sdk-py";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
