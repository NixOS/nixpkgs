{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pybind11-stubgen";
  version = "2.5.1";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "sizmailov";
    repo = "pybind11-stubgen";
    rev = "refs/tags/v${version}";
    hash = "sha256-PJiiRSQ92vP5LKWCgBuowkuDdTmC22xyuax2wsH0wOM=";
  };

  # For testing purposes, the upstream source uses a shell script to build the pybind11
  # project and compares the generated stub file with a preset one.
  # This process requires network access and takes considerable time to complete.
  # Therefore, I disabled the check phase.
  doCheck = false;

  pythonImportsCheck = [ "pybind11_stubgen" ];

  meta = {
    changelog = "https://github.com/sizmailov/pybind11-stubgen/releases/tag/v${version}";
    description = "Generates stubs for python modules";
    homepage = "https://github.com/sizmailov/pybind11-stubgen";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
