{ lib, buildPythonPackage, trio, curio, async-timeout, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "python-socks";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n6xb18jy41ybgkmamakg6psp3qididd45qknxiggngaiibz43kx";
  };

  disabled = pythonOlder "3.6.1";

  propagatedBuildInputs = [ trio curio async-timeout ];

  meta = with lib; {
    description = "Core proxy client (SOCKS4, SOCKS5, HTTP) functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ mjlbach ];
  };
}
