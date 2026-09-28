{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  cython,
  ninja,
  scikit-build-core,
  setuptools-scm,

  # dependencies
  typing-extensions,

  # tests
  numpy,
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "apache-tvm-ffi";
  version = "0.1.14-post0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tvm-ffi";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-hIbVt5rPlCTT6BuIXlaEj8Ln6f27NlmtWqEWwx9AvnA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "cython>=3.2.8" \
        "cython"
  '';

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
    setuptools-scm
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    cpp = [
      ninja
    ];
  };

  pythonImportsCheck = [ "tvm_ffi" ];

  nativeCheckInputs = [
    numpy
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Open ABI and FFI for Machine Learning Systems";
    changelog = "https://github.com/apache/tvm-ffi/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/apache/tvm-ffi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
