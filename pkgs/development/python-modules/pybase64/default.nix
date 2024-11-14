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
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mayeut";
    repo = "pybase64";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-Yl0P9Ygy6IirjSFrutl+fmn4BnUL1nXzbQgADNQFg3I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  pythonImportsCheck = [ "pybase64" ];

  meta = {
    description = "Fast Base64 encoding/decoding";
    mainProgram = "pybase64";
    homepage = "https://github.com/mayeut/pybase64";
    changelog = "https://github.com/mayeut/pybase64/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
