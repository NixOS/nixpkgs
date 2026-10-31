{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mayeut";
    repo = "pybase64";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Qz5KvqVtm3Fr3cWRrW5DvATA1yBaZ9TC1U461eYZY7c=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  pythonImportsCheck = [ "pybase64" ];

  meta = {
    description = "Fast Base64 encoding/decoding";
    mainProgram = "pybase64";
    homepage = "https://github.com/mayeut/pybase64";
    changelog = "https://github.com/mayeut/pybase64/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
