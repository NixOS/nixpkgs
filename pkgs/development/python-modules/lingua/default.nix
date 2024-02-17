{ lib
, buildPythonPackage
, chameleon
, click
, fetchFromGitHub
, fetchpatch
, flit-core
, polib
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "lingua";
  version = "4.15.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wichert";
    repo = "lingua";
    rev = "refs/tags/v${version}";
    hash = "sha256-++NAuSq1IshlSkSubq+K4sYKHDBRZzGo8xbSFPkZsKI=";
  };

  patches = [
    # Python 3.12 support, https://github.com/wichert/lingua/pull/110
    (fetchpatch {
      name = "support-py312.patch";
      url = "https://github.com/wichert/lingua/commit/23c6b9cc022bbc420a088a67b42f866cd7bcc752.patch";
      hash = "sha256-qKQc2w95EZnt1EykTA8Vfk1hRKUeG56ziwyAxs4CLjU=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
    polib
    setuptools
  ];

  nativeCheckInputs = [
    chameleon
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lingua"
  ];

  disabledTests = [
    # Test fails due to an UnicodeWarning
    "test_function_argument"
  ];

  meta = with lib; {
    description = "Translation toolset";
    homepage = "https://github.com/wichert/lingua";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
