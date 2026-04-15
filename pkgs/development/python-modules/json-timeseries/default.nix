{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "json-timeseries";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slaxor505";
    repo = "json-timeseries-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5+eS+e6d61CBIqBXFaIQta95nenF5XK2mA9pQ+Rj0vQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "json_timeseries" ];

  meta = {
    changelog = "https://github.com/slaxor505/json-timeseries-py/releases/tag/${finalAttrs.src.tag}";
    description = "JSON Time Series (JTS) spec Python library";
    homepage = "https://github.com/slaxor505/json-timeseries-py";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
