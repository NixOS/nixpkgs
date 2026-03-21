{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pathlib-abc,
  pytestCheckHook,
  setuptools,
  smart-open,
  typer,
}:

buildPythonPackage rec {
  pname = "pathy";
  version = "0.11.0";
  pyproject = true;

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

  meta = {
    # Marked broken 2025-11-28 because it has failed on Hydra for at least one year.
    broken = true;
    # https://github.com/justindujardin/pathy/issues/113
    description = "Path interface for local and cloud bucket storage";
    mainProgram = "pathy";
    homepage = "https://github.com/justindujardin/pathy";
    license = lib.licenses.asl20;
  };
}
