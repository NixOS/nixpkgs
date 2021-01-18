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
  version = "0.2.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95df90d5be581e3c69398abc6a3ec69a4e568852d9d6df4582bfcc0e22ffb3bb";
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
