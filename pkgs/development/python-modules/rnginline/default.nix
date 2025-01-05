{
  lib,
  fetchPypi,
  buildPythonPackage,
  poetry-core,
  lxml,
  docopt-ng,
  typing-extensions,
  importlib-metadata,
  importlib-resources,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "rnginline";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JWqzs+OqOynIAWYVgGrZiuiCqObAgGe6rBt0DcP3U6E=";
  };

  pythonRelaxDeps = [
    "docopt-ng"
    "importlib-metadata"
    "lxml"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    docopt-ng
    lxml
    typing-extensions
    importlib-metadata
    importlib-resources
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rnginline" ];

  meta = with lib; {
    description = "Python library and command-line tool for loading multi-file RELAX NG schemas from arbitary URLs, and flattening them into a single RELAX NG schema";
    homepage = "https://github.com/h4l/rnginline";
    changelog = "https://github.com/h4l/rnginline/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
