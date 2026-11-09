{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-memcached,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cymruwhois";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JustinAzoff";
    repo = "python-cymruwhois";
    tag = version;
    hash = "sha256-d9m668JYI9mxUycoVWyaDCR7SOca+ebymZxWtgSPWNU=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    CACHE = [ python-memcached ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cymruwhois" ];

  disabledTests = [
    # AssertionError
    "test_doctest"
  ];

  disabledTestPaths = [
    # £Failed: 'yield' keyword is allowed in fixtures, but not in tests (test_common)
    "tests/test_common_lookups.py"
  ];

  meta = {
    description = "Python client for the whois.cymru.com service";
    homepage = "https://github.com/JustinAzoff/python-cymruwhois";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
