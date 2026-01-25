{
  lib,
  buildPythonPackage,
  marisa-trie,
  fetchPypi,
  pytestCheckHook,
  language-data,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "3.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QL/zFeAbAdEcKuOSjdT1y9dN04+b2RLBK5o2BsFD9zE=";
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

  meta = {
    description = "Python toolkit for working with and comparing the standardized codes for languages";
    homepage = "https://github.com/georgkrause/langcodes";
    license = lib.licenses.mit;
  };
}
