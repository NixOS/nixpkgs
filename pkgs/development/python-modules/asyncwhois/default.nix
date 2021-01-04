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
  version = "0.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rdmg59jzzfz59b3ckg5187lc0wk9r0pzp9x09nq3xs21mcwqjxz";
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
