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
  version = "5.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "backrefs";
    tag = version;
    hash = "sha256-W75JLoBn990PoO3Ej3nb3BjOGm0c71o8hDDBUFWr8i4=";
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
    changelog = "https://github.com/facelessuser/backrefs/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
