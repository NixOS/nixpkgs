{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov,
  setuptools,
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xlcnd";
    repo = "isbnlib";
    rev = "v${version}";
    hash = "sha256-d6p0wv7kj+NOZJRE2rzQgb7PXv+E3tASIibYCjzCdx8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pytestFlagsArray = [ "isbnlib/test/" ];

  # All disabled tests require a network connection
  disabledTests = [
    "test_cache"
    "test_editions_any"
    "test_editions_merge"
    "test_editions_thingl"
    "test_editions_wiki"
    "test_isbn_from_words"
    "test_desc"
    "test_cover"
  ];

  disabledTestPaths = [
    "isbnlib/test/test_cache_decorator.py"
    "isbnlib/test/test_goom.py"
    "isbnlib/test/test_metadata.py"
    "isbnlib/test/test_openl.py"
    "isbnlib/test/test_rename.py"
    "isbnlib/test/test_webservice.py"
    "isbnlib/test/test_wiki.py"
    "isbnlib/test/test_words.py"
  ];

  pythonImportsCheck = [
    "isbnlib"
    "isbnlib.config"
    "isbnlib.dev"
    "isbnlib.dev.helpers"
    "isbnlib.registry"
  ];

  meta = with lib; {
    description = "Extract, clean, transform, hyphenate and metadata for ISBNs";
    homepage = "https://github.com/xlcnd/isbnlib";
    changelog = "https://github.com/xlcnd/isbnlib/blob/v${version}/CHANGES.txt";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
