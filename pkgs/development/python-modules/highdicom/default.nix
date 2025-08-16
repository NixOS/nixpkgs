{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  numpy,
  pillow,
  pydicom,
  pyjpegls,
  pylibjpeg,
  pylibjpeg-libjpeg,
  pylibjpeg-openjpeg,
  setuptools,
  typing-extensions,
}:

let
  test_data = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom-data";
    rev = "cbb9b2148bccf0f550e3758c07aca3d0e328e768";
    hash = "sha256-nF/j7pfcEpWHjjsqqTtIkW8hCEbuQ3J4IxpRk0qc1CQ=";
  };
in
buildPythonPackage rec {
  pname = "highdicom";
  version = "0.26.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "MGHComputationalPathology";
    repo = "highdicom";
    tag = "v${version}";
    hash = "sha256-zaa0daGMQHktYkG56JA2a7s5UZSv8AbinO5roe9rWQc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pillow
    pydicom
    pyjpegls
    typing-extensions
  ];

  optional-dependencies = {
    libjpeg = [
      pylibjpeg
      pylibjpeg-libjpeg
      pylibjpeg-openjpeg
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.libjpeg;
  preCheck = ''
    export HOME=$TMP/test-home
    mkdir -p $HOME/.pydicom/
    ln -s ${test_data}/data_store/data $HOME/.pydicom/data
  '';

  pythonImportsCheck = [
    "highdicom"
    "highdicom.legacy"
    "highdicom.ann"
    "highdicom.ko"
    "highdicom.pm"
    "highdicom.pr"
    "highdicom.seg"
    "highdicom.sr"
    "highdicom.sc"
  ];

  # updates the wrong fetcher
  passthru.skipBulkUpdate = true;

  meta = {
    description = "High-level DICOM abstractions for Python";
    homepage = "https://highdicom.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/highdicom/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
