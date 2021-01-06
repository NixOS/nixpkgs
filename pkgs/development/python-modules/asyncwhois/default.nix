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
  version = "0.2.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59ed35fbe646491b6c3e1dcf6db9b4870c3d44c6c023a1c3badd6226551d7b7e";
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
