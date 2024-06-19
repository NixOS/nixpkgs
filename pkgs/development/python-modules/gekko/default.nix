{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gekko";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JN7CWOR7CcWzmKDNlUXm/6ilrTJ3vLa8h2TNnmALhfk=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # Module has no tests
  doCHeck = false;

  pythonImportsCheck = [ "gekko" ];

  meta = with lib; {
    description = "Module for machine learning and optimization";
    homepage = "https://github.com/BYU-PRISM/GEKKO";
    changelog = "https://github.com/BYU-PRISM/GEKKO/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ BatteredBunny ];
  };
}
