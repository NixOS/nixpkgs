{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pygithub,
  terminaltables,
  click,
  requests,
}:

buildPythonPackage rec {
  pname = "keep";
  version = "2.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Brwvu/Zevr8sOE3KAwakDDzVMc2VoFxIb1orXAes2U0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    click
    requests
    terminaltables
    pygithub
  ];

  # no tests
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
