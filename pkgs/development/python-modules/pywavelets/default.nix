{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  meson-python,
  cython,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "pywavelets";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyWavelets";
    repo = "pywt";
    tag = "v${version}";
    hash = "sha256-lzf/GVNJjPDd4r5KCddU3E7Ynn1UGrItf+eIt+xQmvo=";
  };

  build-system = [
    meson-python
    cython
    numpy
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd $out
  '';

  # ensure compiled modules are present
  pythonImportsCheck = [
    "pywt"
    "pywt._extensions._cwt"
    "pywt._extensions._dwt"
    "pywt._extensions._pywt"
    "pywt._extensions._swt"
  ];

  meta = {
    description = "Wavelet transform module";
    homepage = "https://github.com/PyWavelets/pywt";
    changelog = "https://github.com/PyWavelets/pywt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
  };
}
