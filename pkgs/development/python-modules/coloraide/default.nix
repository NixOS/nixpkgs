{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  typing-extensions,
}:
let
  version = "8.13";
in
buildPythonPackage {
  pname = "coloraide";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "coloraide";
    tag = version;
    hash = "sha256-L579fIN8K867gZK8Wy2EHQEDbglu1pFHOxV82boYDOg=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "coloraide"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library to aid in using colors";
    homepage = "https://github.com/facelessuser/coloraide";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
      lib.maintainers.djacu
    ];
  };
}
