{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  medvol,
}:

buildPythonPackage rec {
  pname = "napari-nifti";
  version = "0.0.17";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "napari-nifti";
    tag = "v${version}";
    hash = "sha256-JDyJMg6rsGkfEHBwqKc2L6oRO5Y1MJJlEjUuuqp7URQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ medvol ];

  pythonImportsCheck = [ "napari_nifti" ];

  doCheck = false; # no tests

  meta = {
    description = "Napari plugin for reading and writing NIFTI files";
    homepage = "https://github.com/MIC-DKFZ/napari-nifti";
    changelog = "https://github.com/MIC-DKFZ/napari-nifti/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
