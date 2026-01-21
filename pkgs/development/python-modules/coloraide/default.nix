{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  typing-extensions,
}:
let
  version = "7.0";
in
buildPythonPackage {
  pname = "coloraide";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "coloraide";
    tag = version;
    hash = "sha256-RjccFdsI7VAVieyVR2XbMTuG2SgPGCLzxjPrJ5G7tIo=";
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
