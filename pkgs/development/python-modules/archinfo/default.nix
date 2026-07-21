{
  lib,
  backports-strenum,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.154";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "archinfo";
    tag = "v${version}";
    hash = "sha256-Vks7Rjd8x2zeHnJPs0laH56S4b8pnR1cK82SpK+XOgE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
