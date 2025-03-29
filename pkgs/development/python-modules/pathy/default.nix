{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pathlib-abc,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  smart-open,
  typer,
}:

buildPythonPackage rec {
  pname = "pathy";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uz0OawuL92709jxxkeluCvLtZcj9tfoXSI+ch55jcG0=";
  };

  pythonRelaxDeps = [ "smart-open" ];

  build-system = [ setuptools ];

  dependencies = [
    pathlib-abc
    smart-open
    typer
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Exclude tests that require provider credentials
    "pathy/_tests/test_clients.py"
    "pathy/_tests/test_gcs.py"
    "pathy/_tests/test_s3.py"
  ];

  pythonImportsCheck = [ "pathy" ];

  meta = with lib; {
    description = "Path interface for local and cloud bucket storage";
    mainProgram = "pathy";
    homepage = "https://github.com/justindujardin/pathy";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
