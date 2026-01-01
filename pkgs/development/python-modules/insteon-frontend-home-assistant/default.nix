{
  lib,
  buildPythonPackage,
  fetchPypi,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
<<<<<<< HEAD
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "insteon_frontend_home_assistant";
    inherit version;
    hash = "sha256-oBTk7gblJA6/w0wSx+efdEmY5ioJiRMUfDqjyg0LkFg=";
=======
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NZwnx8tlXnsVCk4nvNjOg3cjSr2CnjqWcZG7xFTC2wA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "insteon_frontend" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/pyinsteon/insteon-panel/releases/tag/${version}";
    description = "Insteon frontend for Home Assistant";
    homepage = "https://github.com/pyinsteon/insteon-panel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    changelog = "https://github.com/pyinsteon/insteon-panel/releases/tag/${version}";
    description = "Insteon frontend for Home Assistant";
    homepage = "https://github.com/pyinsteon/insteon-panel";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
