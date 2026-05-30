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
  setuptools,
  versioningit,
}:

buildPythonPackage rec {
  pname = "heudiconv";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xjPfKwYG2gh/USaMKyrdtHgmefjEZHgx9SUg93htVVU=";
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

    # tries to access internet
    "test_partial_xa_conversion"
  ];

  meta = {
    description = "Flexible DICOM converter for organizing imaging data";
    homepage = "https://heudiconv.readthedocs.io";
    changelog = "https://github.com/nipy/heudiconv/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
