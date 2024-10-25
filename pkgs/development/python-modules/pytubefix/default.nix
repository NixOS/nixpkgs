{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pytubefix";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanBindez";
    repo = "pytubefix";
    rev = "refs/tags/v${version}";
    hash = "sha256-jZHSvOB0kCeiguLmYDjXcMbMqLWCOO/5+spV5p6Hl3I=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  disabledTestPaths = [
    # require network access
    "tests/test_captions.py"
    "tests/test_cli.py"
    "tests/test_cipher.py"
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
