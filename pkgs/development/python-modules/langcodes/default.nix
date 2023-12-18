{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, poetry-core
, pytestCheckHook
, language-data
, setuptools
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "3.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    language-data
    marisa-trie
    setuptools # pkg_resources import in language_data/util.py
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert 'Unknown language [aqk]' == 'Aninka'
    "test_updated_iana"
  ];

  pythonImportsCheck = [
    "langcodes"
  ];

  meta = with lib; {
    description = "Python toolkit for working with and comparing the standardized codes for languages";
    homepage = "https://github.com/LuminosoInsight/langcodes";
    license = licenses.mit;
  };
}
