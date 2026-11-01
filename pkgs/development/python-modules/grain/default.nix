{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  pybind11,
  setuptools,

  # buildInputs
  abseil-cpp,

  # dependencies
  absl-py,
  array-record,
  cloudpickle,
  etils,
  numpy,
  portpicker,
  protobuf,

  # optional-dependencies
  pyarrow,

  # tests
  attrs,
  jax,
  parameterized,
  prometheus-client,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "grain";
  version = "0.2.18";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "grain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vrmQY/fuh0EQOOYUm3IQNKmr8d+fz/9f23vqTf1PxnQ=";
  };

  # Upstream builds the native extension and the protobuf bindings with Bazel.
  # Replace it with a plain setuptools/pybind11 build.
  postPatch = ''
    cat > setup.py <<EOF
    import setuptools
    from pybind11.setup_helpers import Pybind11Extension

    setuptools.setup(
        ext_modules=[
            Pybind11Extension(
                "grain._src.python.experimental.index_shuffle.python.index_shuffle_module",
                [
                    "grain/_src/python/experimental/index_shuffle/index_shuffle.cc",
                    "grain/_src/python/experimental/index_shuffle/python/index_shuffle_module.cc",
                ],
                include_dirs=["."],
                libraries=["absl_strings"],
                cxx_std=20,
            ),
        ],
    )
    EOF
  '';

  # protoc is propagated by the python protobuf package
  preBuild = ''
    protoc --python_out=. grain/proto/execution_summary.proto
  '';

  build-system = [
    pybind11
    setuptools
  ];

  buildInputs = [
    abseil-cpp
  ];

  dependencies = [
    absl-py
    array-record
    cloudpickle
    etils
    numpy
    portpicker
    protobuf
  ]
  ++ etils.optional-dependencies.epath
  ++ etils.optional-dependencies.epy;

  optional-dependencies = {
    parquet = [ pyarrow ];
  };

  pythonImportsCheck = [
    "grain"
    "grain.experimental"
    "grain.python"
  ];

  nativeCheckInputs = [
    attrs
    jax
    parameterized
    prometheus-client
    pytestCheckHook
    typing-extensions
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Tests live inside the package: run them against the installed copy, which has the
  # compiled extension.
  preCheck = ''
    rm -rf grain
  '';
  enabledTestPaths = [
    "${placeholder "out"}/${python.sitePackages}/grain"
  ];
  disabledTestPaths = [
    # Requires tensorflow
    "${placeholder "out"}/${python.sitePackages}/grain/_src/core/tf_import_smoke_test.py"
  ];
  disabledTests = [
    # Hangs in the sandbox
    "test_multi_processes_co_read"
  ];

  pytestFlags = [
    "-pno:cacheprovider"
    "-opython_files=*_test.py"
  ];

  meta = {
    description = "Library for reading and processing ML training data";
    homepage = "https://github.com/google/grain";
    changelog = "https://github.com/google/grain/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
