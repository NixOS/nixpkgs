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
  version = "2.15.3";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.pyicu.org";
    owner = "main";
    repo = "pyicu";
    tag = "v${version}";
    hash = "sha256-vbrl6n7X85sQIdgj+Z0Xr6x/L8roK5Z/mNj53zyWQGs=";
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

  meta = {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = lib.licenses.mit;
  };
}
