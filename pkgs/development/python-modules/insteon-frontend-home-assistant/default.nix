{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.6.2";
  pyproject = true;

  src = fetchPypi {
    pname = "insteon_frontend_home_assistant";
    inherit version;
    hash = "sha256-p5hL8LE8h/4ytHft/v23uzv7YwR9UBDVru8n7WeY99Q=";
  };

  nativeBuildInputs = [ setuptools ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "insteon_frontend" ];

  meta = {
    changelog = "https://github.com/pyinsteon/insteon-panel/releases/tag/${version}";
    description = "Insteon frontend for Home Assistant";
    homepage = "https://github.com/pyinsteon/insteon-panel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
