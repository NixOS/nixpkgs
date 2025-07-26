{
  buildPythonPackage,
  fetchPypi,
  lib,
  hatchling,
  black,
  lxml,
  pytest,
  requests,
  ruff,
}:

buildPythonPackage rec {
  pname = "python_wayland_extra";
  version = "0.7.0";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-HSBOCWP3o/BHmg3LO+LU+GpYkEYSqdljjYcEPdOnxZk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    black
    lxml
    pytest
    requests
    ruff
  ];

  pyproject = true;

  pythonImportsCheck = [ "wayland" ];

  meta = {
    description = "Implementation of the Wayland protocol with no external dependencies";
    homepage = "https://github.com/dennisrijsdijk/python-wayland-extra";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.linux;
  };
}
