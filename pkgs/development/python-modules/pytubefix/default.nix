{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  nodejs,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "10.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanBindez";
    repo = "pytubefix";
    tag = "v${version}";
    hash = "sha256-XfcFpJRMcXGcGeo36QhBEi7iT6Lsf1yq2F1iz/jq7oQ=";
  };

  patches = [
    (replaceVars ./replace-nodejs-wheel-binaries.patch {
      inherit nodejs;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_captions.py"
    "tests/test_cli.py"
    "tests/test_exceptions.py"
    "tests/test_extract.py"
    "tests/test_main.py"
    "tests/test_query.py"
    "tests/test_streams.py"
  ];

  disabledTests = [
    "test_get_initial_function_name_with_no_match_should_error"
    "test_get_throttling_function_name"
    "test_playlist_failed_pagination"
    "test_playlist_pagination"
    "test_create_mock_html_json"
  ];

  pythonImportsCheck = [ "pytubefix" ];

  meta = {
    description = "Pytube fork with additional features and fixes";
    homepage = "https://github.com/JuanBindez/pytubefix";
    changelog = "https://github.com/JuanBindez/pytubefix/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
