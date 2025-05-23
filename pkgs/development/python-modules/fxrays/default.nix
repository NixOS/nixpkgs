{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  cython,
}:

buildPythonPackage rec {
  pname = "fxrays";
  version = "1.3.6";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit version;
    pname = "FXrays";
    sha256 = "sha256-epNUWne1P/QJjSyXaMxUIrVKyMMXl9uWFgukiJTbHGg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  doCheck = true;

  pythonImportsCheck = [ "FXrays" ];

  meta = with lib; {
    description = "Computes extremal rays of polyhedral cones with filtering";
    homepage = "https://github.com/3-manifolds/FXrays";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
