{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  flit-core,
  pygithub,
  requests,
  terminaltables3,
}:

buildPythonPackage rec {
  pname = "keep";
  version = "2.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Brwvu/Zevr8sOE3KAwakDDzVMc2VoFxIb1orXAes2U0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    click
    pygithub
    requests
    terminaltables3
  ];

  # Module no tests
  doCheck = false;

  pythonImportsCheck = [ "keep" ];

  meta = {
    description = "Meta CLI toolkit to keep personal shell command keeper and manage snippets";
    homepage = "https://github.com/OrkoHunter/keep";
    changelog = "https://github.com/OrkoHunter/keep/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ris ];
    mainProgram = "keep";
  };
}
