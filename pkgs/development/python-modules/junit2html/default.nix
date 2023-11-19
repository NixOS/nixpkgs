{ lib
, fetchPypi
, buildPythonPackage
, nix-update-script

, setuptools
, wheel

, jinja2
}:

buildPythonPackage rec {
  pname = "junit2html";
  version = "30.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1q6KpKdrZvp8XvxGCkoorlZDDgvGg/imTX8+NEOBbWs=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    jinja2
  ];

  pythonImportsCheck = [ "junit2htmlreport" ];

  meta = with lib; {
    description = "Generate HTML reports from Junit results";
    homepage = "https://pypi.org/project/junit2html/";
    license = licenses.mit;
    maintainers = with maintainers; [ otavio ];
    mainProgram = "junit2html";
  };
}
