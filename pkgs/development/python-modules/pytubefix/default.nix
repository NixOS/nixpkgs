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
  version = "6.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanBindez";
    repo = "pytubefix";
    rev = "refs/tags/v${version}";
    hash = "sha256-7AHmRAJ8wL8/V5uQyjdsEUxHQz0n+3pxi9FpMsM1l4U=";
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
    # require network access
    "tests/test_captions.py"
    "tests/test_cli.py"
    "tests/test_exceptions.py"
    "tests/test_extract.py"
    "tests/test_main.py"
    "tests/test_query.py"
    "tests/test_streams.py"
    "tests/contrib/test_playlist.py"
  ];

  pythonImportsCheck = [ "pytubefix" ];

  meta = {
    homepage = "https://github.com/JuanBindez/pytubefix";
    description = "Pytube fork with additional features and fixes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
