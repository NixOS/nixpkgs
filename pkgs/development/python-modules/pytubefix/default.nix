{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  disabledTestPaths = [
    # require network access
    "tests/test_captions.py"
    "tests/test_cli.py"
    "tests/test_exceptions.py"
    "tests/test_extract.py"
    "tests/test_main.py"
    "tests/test_query.py"
    "tests/test_streams.py"
  ];

  pythonImportsCheck = [ "pytubefix" ];

  meta = {
    homepage = "https://github.com/JuanBindez/pytubefix";
    description = "Pytube fork with additional features and fixes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
