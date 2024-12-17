{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  pygments,
}:

buildPythonPackage rec {
  pname = "accessible-pygments";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "accessible_pygments";
    inherit version;
    hash = "sha256-QJGNPmorYZrUJMuR5Va9O9iGVEPZ8i8dzfeeM8gEaHI=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

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
    maintainers = [ ];
  };
}
