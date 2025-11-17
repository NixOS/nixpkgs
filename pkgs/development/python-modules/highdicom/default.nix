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

buildPythonPackage rec {
  pname = "highdicom";
  version = "0.27.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "MGHComputationalPathology";
    repo = "highdicom";
    tag = "v${version}";
    hash = "sha256-Tfy7u5MVapRE24CZLFzTnYChnH9JJ9V7FuUhDoktBFc=";
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
    ln -s ${pydicom.passthru.pydicom-data}/data_store/data $HOME/.pydicom/data
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

  meta = {
    description = "High-level DICOM abstractions for Python";
    homepage = "https://highdicom.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/highdicom/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
