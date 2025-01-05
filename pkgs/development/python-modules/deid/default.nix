{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  matplotlib,
  pydicom,
  python-dateutil,
  setuptools,
}:

let
  deid-data = buildPythonPackage rec {
    pname = "deid-data";
    version = "unstable-2022-12-06";
    pyproject = true;

    disabled = pythonOlder "3.7";

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
  version = "0.3.25";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # Pypi version has no tests
  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    # the github repo does not contain Pypi version tags:
    rev = "830966d52846c6b721fabb4cc1c75f39eabd55cc";
    hash = "sha256-+slwnQSeRHpoCsvZ24Gq7rOBpQL37a6Iqrj4Mqj6PCo=";
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
  ];

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
