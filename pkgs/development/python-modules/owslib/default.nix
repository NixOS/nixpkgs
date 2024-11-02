{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "owslib";
  version = "0.32.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "geopython";
    repo = "OWSLib";
    rev = "refs/tags/${version}";
    hash = "sha256-q2O9FNBszNWfL1ekcohSd1RbdLFu8c+zxi+UFeQ7/mk=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace-fail " --doctest-modules --doctest-glob 'tests/**/*.txt'" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    lxml
    python-dateutil
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "owslib" ];

  preCheck = ''
    # _pytest.pathlib.ImportPathMismatchError: ('owslib.swe.sensor.sml', '/build/source/build/...
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  pytestFlagsArray = [
    # Disable tests which require network access
    "-m 'not online'"
  ];

  disabledTestPaths = [
    # Tests requires network access
    "tests/test_ogcapi_connectedsystems_osh.py"
  ];

  meta = with lib; {
    description = "Client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    changelog = "https://github.com/geopython/OWSLib/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
