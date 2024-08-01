{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "python-whois";
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_whois";
    inherit version;
    hash = "sha256-d7xzR7+BXWXM0ZZxHCmDdlLwdYWu2tPDwE3YhWUf16c=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  disabledTests = [
    # Exclude tests that require network access
    "test_dk_parse"
    "test_ipv4"
    "test_ipv6"
    "test_choose_server"
    "test_simple_ascii_domain"
    "test_simple_unicode_domain"
  ];

  pythonImportsCheck = [ "whois" ];

  meta = with lib; {
    description = "Python module to produce parsed WHOIS data";
    homepage = "https://github.com/richardpenman/whois";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
