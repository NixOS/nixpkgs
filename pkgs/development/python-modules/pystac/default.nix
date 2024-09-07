{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  html5lib,
  jsonschema,
  pytest-cov,
  pytest-mock,
  pytest-recording,
  python-dateutil,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pystac";
  version = "1.10.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "pystac";
    rev = "v${version}";
    hash = "sha256-zJGDhKRX50Muo1YDEzfwypMLISnYBYKkPvUULYkUf68=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [
    html5lib
    jsonschema
    pytestCheckHook
    pytest-cov
    pytest-mock
    pytest-recording
    requests-mock
  ];

  pythonImportsCheck = [ "pystac" ];

  meta = {
    description = "Python library for working with any SpatioTemporal Asset Catalog (STAC)";
    homepage = "https://github.com/stac-utils/pystac";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members;
  };
}
