{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libsamplerate,
  numpy,
  pybind11,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "samplerate-ledfx";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "python-samplerate-ledfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SLmaWSq/Ou23BfdWKlzE9gIfORgF9skUVEw1Tzpd5b4=";
  };

  patches = [
    # Fix Python 3.14 support based on https://github.com/tuxu/python-samplerate/commit/06e88d1a869db30ce9037498f4dec2f74601d127
    # but with fixes that it applies
    ./fix-python3.14-support.diff
  ];

  # unvendor pybind11, libsamplerate
  postPatch = ''
    rm -r external
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(external)" "find_package(pybind11 REQUIRED)"
  '';

  build-system = [
    cmake
    pybind11
    setuptools
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ libsamplerate ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # timing sensitive: AssertionError: Expected speedup > 1.0, got 0.68x
    "tests/test_threading_performance.py::test_conditional_gil_release_large_data_threading"
  ];

  pythonImportsCheck = [ "samplerate" ];

  meta = {
    description = "Bindings for libsamplerate based on CFFI and NumPy";
    homepage = "https://github.com/LedFx/python-samplerate-ledfx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
