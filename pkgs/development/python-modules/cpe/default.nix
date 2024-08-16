{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cpe";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "nilp0inter";
    repo = "cpe";
    rev = "refs/tags/v${version}";
    hash = "sha256-nHFgsFNoDf1VJI7XOe62NOuL67AZCP/LFsymt7Q8L2U=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cpe" ];

  meta = {
    changelog = "https://github.com/nilp0inter/cpe/releases/tag/v${version}";
    description = "Common platform enumeration for python";
    homepage = "https://github.com/nilp0inter/cpe";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
