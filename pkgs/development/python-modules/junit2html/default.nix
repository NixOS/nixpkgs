{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "junit2html";
  version = "30.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1q6KpKdrZvp8XvxGCkoorlZDDgvGg/imTX8+NEOBbWs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ jinja2 ];

  # Tests are not shipped with PyPi and source is not tagged
  doCheck = false;

  pythonImportsCheck = [ "junit2htmlreport" ];

  meta = {
    description = "Generate HTML reports from Junit results";
    homepage = "https://gitlab.com/inorton/junit2html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "junit2html";
  };
}
