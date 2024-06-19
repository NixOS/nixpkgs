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
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "item_synchronizer";
    rev = "v${version}";
    hash = "sha256-+mviKtCLlJhYV576Q07kcFJvtls5qohKSrqZtBqE/s4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'bidict = "^0.21.4"' 'bidict = "^0.23"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    bidict
    bubop
  ];

  pythonImportsCheck = [ "item_synchronizer" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/bergercookie/item_synchronizer";
    changelog = "https://github.com/bergercookie/item_synchronizer/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
