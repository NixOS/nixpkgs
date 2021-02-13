{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiodns
, tldextract
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asyncwhois";
  version = "0.2.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84677e90bc2d2975788e905ae9841bc91a732a452bc870991105b0a6cc3cd22f";
  };

  propagatedBuildInputs = [
    aiodns
    tldextract
  ];

  # tests are only present at GitHub but not the released source tarballs
  # https://github.com/pogzyb/asyncwhois/issues/10
  doCheck = false;
  pythonImportsCheck = [ "asyncwhois" ];

  meta = with lib; {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
