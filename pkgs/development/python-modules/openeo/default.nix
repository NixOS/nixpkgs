{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,

  # build-system
  setuptools,

  # Python deps
  requests,
  urllib3,
  shapely,
  numpy,
  pandas,
  pystac,
  deprecated,
  xarray,

  # Tests
  pytest,
  httpretty,
  geopandas,
  dirty-equals,
  mock,
  time-machine,
  requests-mock,
  pystac-client
}:

buildPythonPackage rec {
  pname = "openeo";
  version = "0.43.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Open-EO";
    repo = "openeo-python-client";
    tag = "v${version}";
    hash = "sha256-zeUASaj1XbcH8NE2+AalH8Jc0tocwotKwJ5QAtrf0kE=";
  };

  # pythonRelaxDeps = [
  # ];
  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
    shapely
    numpy
    pandas
    pystac
    deprecated
    xarray
  ];

  nativeCheckInputs = [
    pytest
    httpretty
    geopandas
    dirty-equals
    mock
    time-machine
    requests-mock
  pystac-client
  ];

  checkPhase = ''
    runHook preCheck

    pytest

    runHook postCheck
  '';

  pythonImportsCheck = [
    "openeo"
  ];

  meta = {
    changelog = "https://github.com/Open-EO/openeo-python-client/releases/tag/${src.tag}";
    description = "Python client API for OpenEO";
    homepage = "https://open-eo.github.io/openeo-python-client/";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [
      elrohirgt
    ];
  };
}
