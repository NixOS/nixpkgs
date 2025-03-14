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
  version = "0.4.0";
  pyproject = true;

  # Pypi version has no tests
  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "deid";
    # the github repo does not contain Pypi version tags:
    rev = "14d1e4eb70f2c9fda43fca411794be9d8a5a8516";
    hash = "sha256-YsLWHIO6whcBQriMYb0tDD9s/RrxlfeKGORF1UCOilI=";
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
  versionCheckProgramArg = [ "--version" ];

  pythonImportsCheck = [ "deid" ];

  meta = {
    description = "Best-effort anonymization for medical images";
    mainProgram = "deid";
    changelog = "https://github.com/pydicom/deid/blob/${version}/CHANGELOG.md";
    homepage = "https://pydicom.github.io/deid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
