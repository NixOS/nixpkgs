{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "9.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanBindez";
    repo = "pytubefix";
    tag = "v${version}";
    hash = "sha256-Abx4VIA8dnEZpl86IyGJYSR8n6sPmtCTq5eJbqKyNRM=";
  };

  build-system = [ setuptools ];

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
