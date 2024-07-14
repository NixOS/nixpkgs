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
  version = "2.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OrvkRTR3Ec7NnLuA2rSgd3QYly/BShTpOH0NKuS2rbc=";
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
