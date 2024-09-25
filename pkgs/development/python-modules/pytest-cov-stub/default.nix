{
  lib,
  buildPythonPackage,
  hatchling,
}:

buildPythonPackage rec {
  pname = "pytest-cov-stub";
  # please use pythonRemoveDeps rather than change this version
  version = (lib.importTOML ./src/pyproject.toml).project.version;
  pyproject = true;

  src = ./src;

  build-system = [ hatchling ];

  meta = with lib; {
    description = "Nixpkgs checkPhase stub for pytest-cov";
    license = licenses.mit;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
