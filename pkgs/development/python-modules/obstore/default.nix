{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  arro3-core,
  docker,
  fsspec,
  minio,
  polars,
  pyarrow,
  pystac-client,
  pytest-asyncio,
  pytest-mypy-plugins,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "obstore";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "obstore";
    tag = "py-v${finalAttrs.version}";
    hash = "sha256-1zMIcr36VrNX3GT4k7w4sIhAwQSWUuuomf73fnCwueY=";
  };

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pyo3-file-0.15.0" = "sha256-8OVShM+jWHOZ/bOXJI2PEDzmOAFY1MBwbkg5ita25cg=";
    };
  };

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  maturinBuildFlags = [
    "-m"
    "obstore/Cargo.toml"
  ];

  pythonImportsCheck = [ "obstore" ];

  nativeCheckInputs = [
    arro3-core
    docker
    fsspec
    minio
    polars
    pyarrow
    pystac-client
    pytest-asyncio
    pytest-mypy-plugins
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires internet access
    "tests/auth/test_planetary_computer.py"

    # error: Cannot find implementation or library stub for module named "obspec"
    "tests/obspec/test-store.yml"
  ];

  disabledTests = [
    # docker.errors.DockerException: Error while fetching server API version:
    # ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))
    "test_cat_ranges_error"
    "test_cat_ranges_one"
    "test_cat_ranges_two"
    "test_construct_store_cache_diff_bucket_name"
    "test_construct_store_cache_same_bucket_name"
    "test_delete_prefix"
    "test_fsspec_filesystem_cache"
    "test_get_async"
    "test_info"
    "test_info_async"
    "test_list"
    "test_list_async"
    "test_multi_file_ops"
    "test_put_files"
    "test_put_files_async"
    "test_remote_parquet"
    "test_split_path"

    # Require internet access
    # obstore.exceptions.GenericError: Generic S3 error: Error performing list request
    "test_from_url"
    "test_pickle"
  ];

  meta = {
    description = "Simple, high-throughput Python interface to S3, GCS & Azure Storage, powered by Rust";
    homepage = "https://github.com/developmentseed/obstore";
    changelog = "https://github.com/developmentseed/obstore/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
