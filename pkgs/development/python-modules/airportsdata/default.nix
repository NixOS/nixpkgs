{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "airportsdata";
  version = "20241001";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+gvRQ7T0vjVXy4kvoGEu8hD9kakr1yC02CId5Xak+gA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "airportsdata" ];

  meta = {
    description = "Extensive database of location and timezone data for nearly every operational airport";
    homepage = "https://github.com/mborsetti/airportsdata/";
    changelog = "https://github.com/mborsetti/airportsdata/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danieldk ];
  };
}
