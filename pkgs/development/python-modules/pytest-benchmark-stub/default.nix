{
  lib,
  buildPythonPackage,
  hatchling,
}:

buildPythonPackage {
  pname = "pytest-benchmark-stub";
  version = (lib.importTOML ./src/pyproject.toml).project.version;
  pyproject = true;

  src = ./src;

  build-system = [ hatchling ];

  meta = {
    description = "Nixpkgs checkPhase stub for pytest-benchmark";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.SuperSandro2000 ];
  };
}
