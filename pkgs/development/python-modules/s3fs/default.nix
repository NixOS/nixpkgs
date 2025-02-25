{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # buildInputs
  docutils,

  # build-system
  setuptools,

  # dependencies
  aiobotocore,
  aiohttp,
  fsspec,

  # tests
  flask,
  flask-cors,
  moto,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2025.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "s3fs";
    tag = version;
    hash = "sha256-nnfvccORDspj54sRxL3d0hn4MpzKYGKE2Kl0v/wLaNw=";
  };

  buildInputs = [ docutils ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "fsspec"
  ];

  dependencies = [
    aiobotocore
    aiohttp
    fsspec
  ];

  pythonImportsCheck = [ "s3fs" ];

  nativeCheckInputs = [
    flask
    flask-cors
    moto
    pytestCheckHook
  ];

  disabledTests = [
    # require network access
    "test_async_close"

    # AssertionError: assert ['x', 'y'] == []
    "test_with_data"

    # AssertionError: assert ['1', 'x', 'y'] == []
    "test_clear_empty"
    "test_no_dircache"

    # KeyError: 'ChecksumAlgorithm'
    "test_info"

    # KeyError:
    # del d[1]
    "test_complex_keys"

    # TypeError: string indices must be integers, not 'str'
    "test_bucket_versioning"
    "test_bulk_delete"
    "test_copy_with_source_and_destination_as_list"
    "test_cp_directory_recursive"
    "test_dynamic_add_rm"
    "test_get_directory_to_existing_directory"
    "test_get_directory_to_new_directory"
    "test_get_directory_without_files_with_same_name_prefix"
    "test_get_file_info_with_selector"
    "test_get_file_to_existing_directory"
    "test_get_file_to_file_in_existing_directory"
    "test_get_file_to_file_in_new_directory"
    "test_get_file_to_new_directory"
    "test_get_glob_edge_cases"
    "test_get_glob_to_existing_directory"
    "test_get_glob_to_new_directory"
    "test_get_list_of_files_to_existing_directory"
    "test_get_list_of_files_to_new_directory"
    "test_get_with_source_and_destination_as_list"
    "test_move[False]"
    "test_move[True]"
    "test_new_bucket"
    "test_new_bucket_auto"
    "test_pipe_exclusive"
    "test_put_directory_recursive"
    "test_put_directory_to_existing_directory"
    "test_put_directory_to_new_directory"
    "test_put_directory_without_files_with_same_name_prefix"
    "test_put_file_to_existing_directory"
    "test_put_file_to_file_in_existing_directory"
    "test_put_file_to_file_in_new_directory"
    "test_put_file_to_new_directory"
    "test_put_glob_edge_cases"
    "test_put_glob_to_existing_directory"
    "test_put_glob_to_new_directory"
    "test_put_list_of_files_to_existing_directory"
    "test_put_list_of_files_to_new_directory"
    "test_rm"
    "test_rm_invalidates_cache"
    "test_rm_recursive_folder"
    "test_s3_big_ls"
    "test_s3fs_etag_preserving_multipart_copy"
    "test_tags"

    # ExceptionGroup: errors while tearing down <Function test_copy_two_files_new_directory> (2 sub-exceptions)
    "test_copy_directory_to_existing_directory"
    "test_copy_directory_to_new_directory"
    "test_copy_directory_without_files_with_same_name_prefix"
    "test_copy_file_to_existing_directory"
    "test_copy_file_to_file_in_existing_directory"
    "test_copy_file_to_file_in_new_directory"
    "test_copy_file_to_new_directory"
    "test_copy_glob_edge_cases"
    "test_copy_glob_to_existing_directory"
    "test_copy_glob_to_new_directory"
    "test_copy_list_of_files_to_existing_directory"
    "test_copy_list_of_files_to_new_directory"
    "test_copy_two_files_new_directory"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Pythonic file interface for S3";
    homepage = "https://github.com/fsspec/s3fs";
    changelog = "https://github.com/fsspec/s3fs/blob/${version}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
