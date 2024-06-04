{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pymediaroom";
  version = "0.6.5.4";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CZh2knpLT7xt5s6+kTQ4Mq9LcpKgWvgdFCkPtMucJTM=";
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
