{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pybind11,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyspeex-noise";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyspeex-noise";
    rev = "refs/tags/${version}";
    hash = "sha256-XtLA5yVVCZdpALPu3fx+U+aaA729Vs1UeOJsIm6/S+k=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  pythonImportsCheck = [ "pyspeex_noise" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/rhasspy/pyspeex-noise/blob/${src.rev}/CHANGELOG.md";
    description = "Noise suppression and automatic gain with speex";
    homepage = "https://github.com/rhasspy/pyspeex-noise";
    license = with lib.licenses; [
      mit # pyspeex-noise
      bsd3 # speex (vendored)
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
