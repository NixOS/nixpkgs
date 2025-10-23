{
  lib,
  buildPythonPackage,
  datalad,
  dcm2niix,
  dcmstack,
  etelemetry,
  fetchPypi,
  filelock,
  git,
  git-annex,
  nibabel,
  nipype,
  pydicom,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  versioningit,
}:

buildPythonPackage rec {
  pname = "heudiconv";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SnYysTsQUagXH8CCPgNoca2ls47XUguE/pJD2wc1tro=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "versioningit ~=" "versioningit >="
  '';

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
    dcmstack
    etelemetry
    filelock
    nibabel
    nipype
    pydicom
  ];

  nativeCheckInputs = [
    datalad
    dcm2niix
    pytestCheckHook
    git
    git-annex
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "heudiconv" ];

  disabledTests = [
    # No such file or directory
    "test_bvals_are_zero"
  ];

  meta = with lib; {
    description = "Flexible DICOM converter for organizing imaging data";
    homepage = "https://heudiconv.readthedocs.io";
    changelog = "https://github.com/nipy/heudiconv/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
