{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  setuptools,
  setuptools-scm,
  pybind11,

  # dependencies
  cffi,
  numpy,

  # native dependencies
  libsamplerate,

  # tests
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "samplerate";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuxu";
    repo = "python-samplerate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7FAdIqsYCapmEAYiAuoS5m/jFExXZX3hn3kwxn9NWEc=";
  };

  patches = [
    # https://github.com/tuxu/python-samplerate/pull/33
    ./numpy-2.4-compat.patch
  ];

  # unvendor pybind11, libsamplerate
  postPatch = ''
    rm -r external
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(external)" "find_package(pybind11 REQUIRED)"
  '';

  build-system = [
    cmake
    setuptools
    setuptools-scm
    pybind11
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ libsamplerate ];

  dependencies = [
    cffi
    numpy
  ];

  pythonImportsCheck = [ "samplerate" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf samplerate
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # ValueError: cannot resize an array that references or is referenced
    "test_callback_with_2x"
    "test_process"
    "test_resize"
  ];

  meta = {
    description = "Python bindings for libsamplerate based on CFFI and NumPy";
    homepage = "https://github.com/tuxu/python-samplerate";
    changelog = "https://github.com/tuxu/python-samplerate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
