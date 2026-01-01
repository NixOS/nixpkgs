{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pkg-config,
  setuptools,
  pytestCheckHook,
  six,
  icu,
}:

buildPythonPackage rec {
  pname = "pyicu";
<<<<<<< HEAD
  version = "2.15.3";
=======
  version = "2.15.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.pyicu.org";
    owner = "main";
    repo = "pyicu";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vbrl6n7X85sQIdgj+Z0Xr6x/L8roK5Z/mNj53zyWQGs=";
=======
    hash = "sha256-Div3c4Lk9VTV1HrmvYKDn1a7moDNjG4OHA9Kv3+niKs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail "'pkg-config'" "'${stdenv.cc.targetPrefix}pkg-config'"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ icu ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  disabledTestPaths = [
    # AssertionError: '$' != 'US Dollar'
    "test/test_NumberFormatter.py::TestCurrencyUnit::testGetName"
    # AssertionError: Lists differ: ['a', 'b', 'c', 'd'] != ['a', 'b', 'c', 'd', ...
    "test/test_UnicodeSet.py::TestUnicodeSet::testIterators"
  ];

  pythonImportsCheck = [ "icu" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
