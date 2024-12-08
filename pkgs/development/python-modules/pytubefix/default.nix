{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "6.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanBindez";
    repo = "pytubefix";
    rev = "refs/tags/v${version}";
    hash = "sha256-FbmVQ+nt/WEwE5vRMo2610TO463CT8nCseqB30uXjSM=";
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
