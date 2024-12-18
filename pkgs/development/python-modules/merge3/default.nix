{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "merge3";
  version = "0.0.15";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0+rCE9hNVt/J45VSrIJGx4YKlAlk6+7YqL5EIvZJK68=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "merge3" ];

  meta = with lib; {
    description = "Python implementation of 3-way merge";
    mainProgram = "merge3";
    homepage = "https://github.com/breezy-team/merge3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
