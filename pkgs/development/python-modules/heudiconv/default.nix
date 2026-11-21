{
  lib,
  buildPythonPackage,
  datalad,
  dcm2niix,
  dcmstack,
  etelemetry,
  fetchPypi,
  filelock,
  git-annex,
  git,
  nibabel,
  nipype,
  pydicom,
  pytestCheckHook,
  setuptools,
  versioningit,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "heudiconv";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZLhlw11bOSEpZf17WXckn8/9nzAEkuRjNhGLYLIks6k=";
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
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "heudiconv" ];

  disabledTests = [
    # No such file or directory
    "test_bvals_are_zero"
    "test_convert_multiorient"
    "test_convert_multiorient_nonunique"

    # tries to access internet
    "test_partial_xa_conversion"
  ];

  meta = {
    description = "Flexible DICOM converter for organizing imaging data";
    homepage = "https://heudiconv.readthedocs.io";
    changelog = "https://github.com/nipy/heudiconv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
