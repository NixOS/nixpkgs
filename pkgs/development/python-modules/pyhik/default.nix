{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhik";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyHik";
    tag = finalAttrs.version;
    hash = "sha256-UlKQxbTnqxdyRYbpecP5OEnCILnAhifIsjEixxvVBjc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  # Tests are disabled due to fragile XML namespace assertions
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyhik"
  ];

  meta = {
    description = "Python API to interact with a Hikvision camera event stream and toggle motion detection";
    homepage = "https://github.com/mezz64/pyHik";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
