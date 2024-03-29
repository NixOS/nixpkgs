{ lib
, buildPythonPackage
, fetchPypi
, future
, nose
, pytestCheckHook
, pythonOlder
, setuptools
, simplejson
}:

buildPythonPackage rec {
  pname = "python-whois";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3TNtNRfqzip2iUBtt7uWraPF50MnQjFRru4+ZCJfYiA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    future
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
    simplejson
  ];

  # Exclude tests that require network access
  disabledTests = [
    "test_dk_parse"
    "test_ipv4"
    "test_ipv6"
  ];
  pythonImportsCheck = [
    "whois"
  ];

  meta = with lib; {
    description = "Python module to produce parsed WHOIS data";
    homepage = "https://github.com/richardpenman/whois";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
