{
  lib,
  buildPythonPackage,
  hatchling,
}:

buildPythonPackage {
  pname = "pytest-cov-stub";
  # please use pythonRemoveDeps rather than change this version
  version = (lib.importTOML ./src/pyproject.toml).project.version;
  pyproject = true;

  src = ./src;

  build-system = [ hatchling ];

<<<<<<< HEAD
  meta = {
    description = "Nixpkgs checkPhase stub for pytest-cov";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Nixpkgs checkPhase stub for pytest-cov";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ lib.maintainers.pbsds ];
  };
}
