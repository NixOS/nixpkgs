{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytanque";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "pytanque";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XTWm7ngtf+aFJds0Gj6OZ3Pskk+3cVLK5/p4EMIAH+4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    typing-extensions
  ];

  # Tests require a running Rocq Petanque server
  doCheck = false;

  pythonImportsCheck = [ "pytanque" ];

  meta = {
    description = "Python client for the Rocq Petanque interaction protocol";
    homepage = "https://github.com/LLM4Rocq/pytanque";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
