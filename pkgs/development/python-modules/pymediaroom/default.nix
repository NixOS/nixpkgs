{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "pymediaroom";
  version = "0.6.4.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = pname;
    rev = version;
    sha256 = "1klf2dxd8rlq3n4b9m03lzwcsasn9vi6m3hzrjqhqnprhrnp0xmy";
  };

  propagatedBuildInputs = [
    async-timeout
    xmltodict
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pymediaroom" ];

  meta = with lib; {
    description = "Python Remote Control for Mediaroom STB";
    homepage = "https://github.com/dgomes/pymediaroom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
