{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    pname = "insteon_frontend_home_assistant";
    inherit version;
    hash = "sha256-r6xXEZFAGgXByl+urpXfzhuCedBPjqkwT8Q0sEHQA2w=";
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
