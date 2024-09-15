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
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "PyWavelets";
    repo = "pywt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Dr6LWGVlYGDD21l1RQ7elScovcen5uuFdJJXe3deB5o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"numpy>=2.0.0rc1,<2.3",' ""
  '';

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
    changelog = "https://github.com/PyWavelets/pywt/releases/tag/v${version}";
    license = licenses.mit;
  };
}
