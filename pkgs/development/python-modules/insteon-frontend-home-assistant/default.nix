{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "insteon_frontend_home_assistant";
    inherit version;
    hash = "sha256-mxG2uUozPwz58Grt2pGkCJ4LVtc+sZXJdy9XBxaoePo=";
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
