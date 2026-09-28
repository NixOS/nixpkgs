{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  regex,
}:

buildPythonPackage rec {
  pname = "backrefs";
  version = "6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "backrefs";
    tag = version;
    hash = "sha256-y0scI6FBvjuvWLx1V3AHiGhtLB2Mk7jCx4hEjOv+ETA=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [ "backrefs" ];

  nativeCheckInputs = [
    pytestCheckHook
    regex
  ];

  meta = {
    description = "Wrapper around re or regex that adds additional back references";
    homepage = "https://github.com/facelessuser/backrefs";
    changelog = "https://github.com/facelessuser/backrefs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
