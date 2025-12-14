{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname;
    version = "0.5.0.post1";
    hash = "sha256-tU4AcmYVaJ3qgiM/44SDRuoRJMFDQoN5FovrnDj2ZJA";
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
