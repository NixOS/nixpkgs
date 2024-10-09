{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  numpy,
  pillow,
  pillow-jpls,
  pydicom,
  pylibjpeg,
  pylibjpeg-libjpeg,
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
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MGHComputationalPathology";
    repo = "highdicom";
    rev = "refs/tags/v${version}";
    hash = "sha256-KHSJWEnm8u0xHkeeLF/U7MY4FfiWb6Q0GQQy2w1mnKw=";
  };

  propagatedBuildInputs = [
    numpy
    pillow
    pillow-jpls
    pydicom
  ];

  optional-dependencies = {
    libjpeg = [
      pylibjpeg
      pylibjpeg-libjpeg
      #pylibjpeg-openjpeg  # broken on aarch64-linux
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

  meta = with lib; {
    description = "High-level DICOM abstractions for Python";
    homepage = "https://highdicom.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/highdicom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
