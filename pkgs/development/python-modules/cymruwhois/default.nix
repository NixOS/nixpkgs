{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-memcached,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cymruwhois";
  version = "1.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "JustinAzoff";
    repo = "python-cymruwhois";
    rev = "refs/tags/${version}";
    hash = "sha256-d9m668JYI9mxUycoVWyaDCR7SOca+ebymZxWtgSPWNU=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    CACHE = [ python-memcached ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cymruwhois" ];

  disabledTests = [
    # Tests require network access
    "test_asn"
    # AssertionError
    "test_doctest"
  ];

  meta = {
    description = "Python client for the whois.cymru.com service";
    homepage = "https://github.com/JustinAzoff/python-cymruwhois";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
