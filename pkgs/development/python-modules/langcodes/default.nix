{
  lib,
  buildPythonPackage,
  marisa-trie,
  pythonOlder,
  fetchPypi,
  pytestCheckHook,
  language-data,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "3.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hu+BaNB+UeExokl//srUtmP2II58OuO43BXFFzSm+AE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    language-data
    marisa-trie
    setuptools # pkg_resources import in language_data/util.py
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError: assert 'Unknown language [aqk]' == 'Aninka'
    "test_updated_iana"
  ];

  pythonImportsCheck = [ "langcodes" ];

  meta = with lib; {
    description = "Python toolkit for working with and comparing the standardized codes for languages";
    homepage = "https://github.com/georgkrause/langcodes";
    license = licenses.mit;
  };
}
