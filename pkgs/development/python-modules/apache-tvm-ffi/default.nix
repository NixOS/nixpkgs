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
  python,
  build,

  # dependencies
  typing-extensions,
  torch,

  # tests
  numpy,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "apache-tvm-ffi";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tvm-ffi";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-XnlM//WW2TbjbmzYBq6itJQ7R3J646UMVQUVhV5Afwc=";
  };

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
    # runtime dependency for torch_c_dlpack_ext
    torch
  ];

  optional-dependencies = {
    cpp = [
      ninja
    ];
  };

  pythonImportsCheck = [ "tvm_ffi" ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  nativeBuildInputs = [
    build
  ];

  # The torch_c_dlpack_ext extension requires tvm-ffi to be installed
  # before it can be built
  postInstall = ''
    pushd addons/torch_c_dlpack_ext
    pyproject-build --no-isolation --outdir dist/ --wheel
    ${python.interpreter} -m installer --prefix $out dist/*.whl
    popd
  '';

  meta = {
    description = "Open ABI and FFI for Machine Learning Systems";
    changelog = "https://github.com/apache/tvm-ffi/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/apache/tvm-ffi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
