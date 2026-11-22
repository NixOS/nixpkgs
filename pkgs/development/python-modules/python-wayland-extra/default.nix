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
  pname = "python-wayland-extra";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "python_wayland_extra";
    hash = "sha256-HSBOCWP3o/BHmg3LO+LU+GpYkEYSqdljjYcEPdOnxZk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "black", "lxml", "requests", "pytest", "ruff"' ""
  '';

  build-system = [ hatchling ];

  dependencies = [
    lxml
    requests
  ];

  # requires working wayland display
  doCheck = false;

  pythonImportsCheck = [ "wayland" ];

  meta = {
    description = "Implementation of the Wayland protocol with no external dependencies";
    homepage = "https://github.com/dennisrijsdijk/python-wayland-extra";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.linux;
  };
}
