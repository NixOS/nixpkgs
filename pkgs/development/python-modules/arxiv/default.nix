{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  feedparser,
  requests,

  # tests
  mock,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "arxiv";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lukasschwab";
    repo = "arxiv.py";
    tag = version;
    hash = "sha256-E1Slg7EWSULY68BrevmJO82L47UVFZBreKLVIDko1x0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    feedparser
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTests = [
    # Require network access
    "test_from_feed_entry"
    "test_download_from_query"
    "test_download_tarfile_from_query"
    "test_download_with_custom_slugify_from_query"
    "test_get_short_id"
    "test_invalid_format_id"
    "test_invalid_id"
    "test_legacy_ids"
    "test_max_results"
    "test_missing_title"
    "test_no_duplicates"
    "test_nonexistent_id_in_list"
    "test_offset"
    "test_query_page_count"
    "test_result_shape"
    "test_search_results_offset"
  ];

  pythonImportsCheck = [ "arxiv" ];

  meta = {
    description = "Python wrapper for the arXiv API";
    homepage = "https://github.com/lukasschwab/arxiv.py";
    changelog = "https://github.com/lukasschwab/arxiv.py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.octvs ];
  };
}
