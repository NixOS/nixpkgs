{ lib
, buildPythonPackage
, fetchPypi
, future
, nose
, pytestCheckHook
, simplejson
}:

buildPythonPackage rec {
  pname = "python-whois";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05jaxbnlw5wck0hl124py364jqrx7a4mmv0hy3d2jzvmp0012sk5";
  };

  propagatedBuildInputs = [ future ];

  checkInputs = [
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
  pythonImportsCheck = [ "whois" ];

  meta = with lib; {
    description = "Python module to produce parsed WHOIS data";
    homepage = "https://github.com/richardpenman/whois";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
