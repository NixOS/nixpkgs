{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "junit2html";
  version = "30.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1q6KpKdrZvp8XvxGCkoorlZDDgvGg/imTX8+NEOBbWs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ jinja2 ];

  # Tests are not shipped with PyPi and source is not tagged
  doCheck = false;

  pythonImportsCheck = [ "junit2htmlreport" ];

<<<<<<< HEAD
  meta = {
    description = "Generate HTML reports from Junit results";
    homepage = "https://gitlab.com/inorton/junit2html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
=======
  meta = with lib; {
    description = "Generate HTML reports from Junit results";
    homepage = "https://gitlab.com/inorton/junit2html";
    license = licenses.mit;
    maintainers = with maintainers; [ otavio ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "junit2html";
  };
}
