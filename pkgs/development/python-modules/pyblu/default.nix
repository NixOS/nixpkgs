{
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  lib,
  poetry-core,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qMbwrRD7ZUsHHOLF9yPvAxiTmJ8vJX1cyHX+4ONtsQ8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  pythonImportsCheck = [ "pyblu" ];

  # no tests on PyPI, no tags on GitHub
  # https://github.com/LouisChrist/pyblu/issues/19
  doCheck = false;

  meta = {
    description = "BluOS API client";
    homepage = "https://github.com/LouisChrist/pyblu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
