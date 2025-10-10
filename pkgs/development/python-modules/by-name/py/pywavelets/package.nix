{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  meson-python,
  cython,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "pywavelets";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "PyWavelets";
    repo = "pywt";
    tag = "v${version}";
    hash = "sha256-UVQWZPuOyUPcWI3cV2u+jQyAZN/RV3aKAT6BQxqRE4M=";
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

  meta = with lib; {
    description = "Wavelet transform module";
    homepage = "https://github.com/PyWavelets/pywt";
    changelog = "https://github.com/PyWavelets/pywt/releases/tag/${src.tag}";
    license = licenses.mit;
  };
}
