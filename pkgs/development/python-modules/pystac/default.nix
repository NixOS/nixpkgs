{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  html5lib,
  jsonschema,
  pytest-cov-stub,
  pytest-mock,
  pytest-recording,
  python-dateutil,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pystac";
  version = "1.12.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "pystac";
    tag = "v${version}";
    hash = "sha256-VTpkQdPydKUb/FGZhfFM/2IDUbsVz903q6s5MxLRlYM=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [
    html5lib
    jsonschema
    pytestCheckHook
    pytest-cov-stub
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
