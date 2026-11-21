{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kicad_netlist_reader";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterpolidoro";
    repo = "kicad_netlist_reader";
    tag = version;
    sha256 = "sha256-tnzJP7kmmphRq/mUsFvglhB7IP3RjPdanbdysoQ7oLU=";
  };

  build-system = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "build-backed" "build-backend"
  '';

  doCheck = true;
  pythonImportsCheck = [ "kicad_netlist_reader" ];

  meta = {
    description = "KiCad python module for interpreting generic netlists which can be used to generate Bills of materials.";
    homepage = "https://github.com/peterpolidoro/kicad_netlist_reader";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
