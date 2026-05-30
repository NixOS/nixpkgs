{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  bidict,
  bubop,
}:

buildPythonPackage rec {
  pname = "item-synchronizer";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "item_synchronizer";
    rev = "v${version}";
    hash = "sha256-+mviKtCLlJhYV576Q07kcFJvtls5qohKSrqZtBqE/s4=";
  };

  nativeBuildInputs = [ poetry-core ];

  pythonRelaxDeps = [
    "bidict"
    "bubop"
  ];

  propagatedBuildInputs = [
    bidict
    bubop
  ];

  pythonImportsCheck = [ "item_synchronizer" ];

  meta = {
    description = "";
    homepage = "https://github.com/bergercookie/item_synchronizer";
    changelog = "https://github.com/bergercookie/item_synchronizer/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
