{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ecpy";
  version = "1.2.5";
  pyproject = true;

  src = fetchPypi {
    pname = "ECPy";
    inherit version;
    hash = "sha256-ljXP+5tuz3/X9yrqFmWCmsdKHScgBtAFfUWmIariAig=";
  };

  build-system = [ setuptools ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "ecpy" ];

  meta = with lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = "https://github.com/ubinity/ECPy";
    changelog = "https://github.com/cslashm/ECPy/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
