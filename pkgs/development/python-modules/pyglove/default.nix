{
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  termcolor,
}:

buildPythonPackage rec {
  pname = "pyglove";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "pyglove";
    tag = "v${version}";
    hash = "sha256-mvLu/zYxtNdG3mIw0rsy2q8vYbF9V9Z0yJgeaRm3qNs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    docstring-parser
    termcolor
  ];

  pythonImportsCheck = [ "pyglove" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/google/pyglove/releases/tag/${src.tag}";
    description = "Library for manipulating Python objects";
    homepage = "https://github.com/google/pyglove";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hendrikheil ];
  };
}
