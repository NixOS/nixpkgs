{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "8.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanBindez";
    repo = "pytubefix";
    tag = "v${version}";
    hash = "sha256-PZxwF8rAPHmPpw6MKI8OVrl7CRNn9ldPnsPmHlAYahM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  patches = [
    # cipher test: correct function name resolution (https://github.com/JuanBindez/pytubefix/pull/316)
    (fetchpatch {
      url = "https://github.com/JuanBindez/pytubefix/commit/25a90fd3552c85944e140e8ba65ef0ded935dcf0.patch";
      hash = "sha256-RXVA6XTrnI3N6/wYm8hSQAg0zXPWMdSairnKuCNlZBs=";
    })
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_captions.py"
    "tests/test_cli.py"
    "tests/test_exceptions.py"
    "tests/test_extract.py"
    "tests/test_main.py"
    "tests/test_query.py"
    "tests/test_streams.py"
    "tests/contrib/test_playlist.py"
  ];

  disabledTests = [
    "test_playlist_failed_pagination"
    "test_playlist_pagination"
    "test_create_mock_html_json"
  ];

  pythonImportsCheck = [ "pytubefix" ];

  meta = {
    description = "Pytube fork with additional features and fixes";
    homepage = "https://github.com/JuanBindez/pytubefix";
    changelog = "https://github.com/JuanBindez/pytubefix/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
