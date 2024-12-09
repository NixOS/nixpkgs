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
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lukasschwab";
    repo = "arxiv.py";
    rev = "refs/tags/${version}";
    hash = "sha256-Niu3N0QTVxucboQx1FQq1757Hjj1VVWeDZn7O7YtjWY=";
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
    changelog = "https://github.com/lukasschwab/arxiv.py/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.octvs ];
  };
}
