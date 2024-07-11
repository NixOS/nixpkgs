{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pygments,
}:

buildPythonPackage rec {
  pname = "accessible-pygments";
  version = "0.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-57V6mxWVjpYBx+nrB6RAyBMoNUWiCXPyV0pfRT0OlT4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pygments ];

  # Tests only execute pygments with these styles
  doCheck = false;

  pythonImportsCheck = [
    "a11y_pygments"
    "a11y_pygments.utils"
  ];

  meta = with lib; {
    description = "Collection of accessible pygments styles";
    homepage = "https://github.com/Quansight-Labs/accessible-pygments";
    changelog = "https://github.com/Quansight-Labs/accessible-pygments/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
