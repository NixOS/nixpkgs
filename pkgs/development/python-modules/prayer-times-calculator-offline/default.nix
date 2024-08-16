{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "prayer-times-calculator-offline";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "prayer_times_calculator_offline";
    inherit version;
    hash = "sha256-vmy1hYZXuDvdjjBN5YivzP+lcwfE86Z9toBzj+kyj14=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "prayer_times_calculator_offline" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Prayer Times Calculator - Offline";
    homepage = "https://github.com/cpfair/prayer-times-calculator-offline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
