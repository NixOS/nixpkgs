{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Python Inputs
  setuptools,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.11.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gLO2EItEjrF7fJ6ww5ta04Rxir3NJKgvhTrTBiuDtBs=";
  };

  build-system = [ setuptools ];

  dependencies = [ ipywidgets ];

  doCheck = false; # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

<<<<<<< HEAD
  meta = {
    description = "Jupyter widgets base for Vue libraries";
    homepage = "https://github.com/mariobuikhuizen/ipyvue";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Jupyter widgets base for Vue libraries";
    homepage = "https://github.com/mariobuikhuizen/ipyvue";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
