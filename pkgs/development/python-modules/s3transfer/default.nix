{
  lib,
  stdenv,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "s3transfer";
  version = "0.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boto";
    repo = "s3transfer";
    tag = finalAttrs.version;
    hash = "sha256-BOK8kfTdxM6CInouXrBsQf4/zgL3l/A+VElh1VJj4mA=";
  };

  build-system = [ setuptools ];

  dependencies = [ botocore ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
  ]
  ++
    # There was a change in python 3.8 that defaults multiprocessing to spawn instead of fork on macOS
    # See https://bugs.python.org/issue33725 and https://github.com/python/cpython/pull/13603.
    # I suspect the underlying issue here is that upstream tests aren't compatible with spawn multiprocessing, and pass on linux where the default is still fork
    lib.optionals stdenv.hostPlatform.isDarwin [ "tests/unit/test_compat.py" ];

  disabledTests = [
    # AssertionError
    "test_allowed_copy_params_are_valid"
    "test_mp_copy_forwards_passthrough_args_to_tag_and_annotation_calls"
    "test_allowed_upload_params_are_valid"
  ];

  pythonImportsCheck = [ "s3transfer" ];

  optional-dependencies = {
    crt = botocore.optional-dependencies.crt;
  };

  meta = {
    description = "Library for managing Amazon S3 transfers";
    homepage = "https://github.com/boto/s3transfer";
    changelog = "https://github.com/boto/s3transfer/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
