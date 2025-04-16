{
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
  version = "2.15";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.pyicu.org";
    owner = "main";
    repo = "pyicu";
    tag = "v${version}";
    hash = "sha256-F3qW0yZBjJ8pmLEW4dWKBFvnyiw5F732DKAI+eLcL+g=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ icu ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pytestFlagsArray = [
    # AssertionError: '$' != 'US Dollar'
    "--deselect=test/test_NumberFormatter.py::TestCurrencyUnit::testGetName"
    # AssertionError: Lists differ: ['a', 'b', 'c', 'd'] != ['a', 'b', 'c', 'd', ...
    "--deselect=test/test_UnicodeSet.py::TestUnicodeSet::testIterators"
  ];

  pythonImportsCheck = [ "icu" ];

  meta = with lib; {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = licenses.mit;
  };
}
