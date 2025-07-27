{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  pystac,
  pytest-benchmark,
  pytest-console-scripts,
  pytest-mock,
  pytest-recording,
  python-dateutil,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pystac-client";
  version = "0.8.6";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "pystac-client";
    tag = "v${version}";
    hash = "sha256-rbRxqR6hZy284JfQu5+dukFTBHllqzjo0k9aWhrkRAU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pystac
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
    pytest-console-scripts
    pytest-mock
    pytest-recording
    requests-mock
  ];

  pytestFlags = [
    "--benchmark-disable"
  ];

  disabledTestMarks = [
    # Tests accessing Internet
    "vcr"
  ];

  pythonImportsCheck = [ "pystac_client" ];

  meta = {
    description = "A Python client for working with STAC Catalogs and APIs";
    homepage = "https://github.com/stac-utils/pystac-client";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
}
