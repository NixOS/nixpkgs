{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  libsamplerate,
  numpy,
  pybind11,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "samplerate-ledfx";
  version = "0.2.6";
  pyproject = true;

  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "python-samplerate-ledfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SLmaWSq/Ou23BfdWKlzE9gIfORgF9skUVEw1Tzpd5b4=";
  };

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

  pythonImportsCheck = [ "samplerate" ];

  meta = {
    description = "Bindings for libsamplerate based on CFFI and NumPy";
    homepage = "https://github.com/LedFx/python-samplerate-ledfx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
