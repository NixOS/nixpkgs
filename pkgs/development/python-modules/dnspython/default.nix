{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
, cacert
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.2.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "0gk00m8zxjghxnzafhars51k5ahd6wfhf123nrc1j5gzlsj6jx8g";
  };

  checkInputs = [
    pytestCheckHook
  ] ++ lib.optional stdenv.isDarwin [
    cacert
  ];

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
    # fails if IPv6 isn't available
    "test_resolver_override"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "dns" ];

  meta = with lib; {
    description = "A DNS toolkit for Python";
    homepage = "https://www.dnspython.org";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ gador ];
  };
}
