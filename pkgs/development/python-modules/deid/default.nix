{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  matplotlib,
  pydicom,
  python-dateutil,
  pytestCheckHook,
  versionCheckHook,
}:

let
  deid-data = buildPythonPackage {
    pname = "deid-data";
    version = "unstable-2022-12-06";
    pyproject = true;

    build-system = [ setuptools ];

    dependencies = [ pydicom ];

    src = fetchFromGitHub {
      owner = "pydicom";
      repo = "deid-data";
      rev = "5750d25a5048fba429b857c16bf48b0139759644";
      hash = "sha256-c8NBAN53NyF9dPB7txqYtM0ac0Y+Ch06fMA1LrIUkbc=";
    };

    meta = {
      description = "Supplementary data for deid package";
      homepage = "https://github.com/pydicom/deid-data";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.bcdarwin ];
    };
  };
in
buildPythonPackage rec {
  pname = "deid";
  version = "0.4.13";
  pyproject = true;

  # Pypi version has no tests
  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "deid";
    # the github repo does not contain Pypi version tags:
    rev = "c95ea77f40be8ccfacda3d757f383a4539c49996";
    hash = "sha256-MIxOEqIuxP5A+fwvlgv2ubI3Z06np0J2s1/7feeBnr8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    pydicom
    python-dateutil
  ];

  nativeCheckInputs = [
    deid-data
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "deid" ];

  disabledTests = [
    "TestRemoveAction" # tries to modify store file belonging to deid-data package
  ];

  meta = {
    description = "Best-effort anonymization for medical images";
    mainProgram = "deid";
    changelog = "https://github.com/pydicom/deid/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://pydicom.github.io/deid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
