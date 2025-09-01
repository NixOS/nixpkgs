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
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "backrefs";
    tag = version;
    hash = "sha256-7kB8z8pNU6eLuz4eSYXkSDL5npowlYsm0hjjh8zcAK0=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
