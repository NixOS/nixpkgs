{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "kicad_netlist_reader";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterpolidoro";
    repo = "kicad_netlist_reader";
    tag = finalAttrs.version;
    hash = "sha256-tnzJP7kmmphRq/mUsFvglhB7IP3RjPdanbdysoQ7oLU=";
  };

  build-system = [
    setuptools
  ];

  patches = [
    # There is a typo error in the source code
    ./fix-build-backend.patch
  ];

  doCheck = true;
  pythonImportsCheck = [ "kicad_netlist_reader" ];

  meta = {
    description = "KiCad python module for interpreting generic netlists which can be used to generate Bills of materials.";
    homepage = "https://github.com/peterpolidoro/kicad_netlist_reader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
