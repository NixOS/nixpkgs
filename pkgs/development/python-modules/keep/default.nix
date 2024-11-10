{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygithub,
  terminaltables,
  click,
  requests,
}:

buildPythonPackage rec {
  pname = "keep";
  version = "2.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Brwvu/Zevr8sOE3KAwakDDzVMc2VoFxIb1orXAes2U0=";
  };

  propagatedBuildInputs = [
    click
    requests
    terminaltables
    pygithub
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "keep" ];

  meta = with lib; {
    homepage = "https://github.com/orkohunter/keep";
    description = "Meta CLI toolkit: Personal shell command keeper and snippets manager";
    mainProgram = "keep";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
