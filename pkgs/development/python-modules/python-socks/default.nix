{ lib, fetchPypi, buildPythonPackage, trio, curio, async-timeout, }:

buildPythonPackage rec {
  pname = "python-socks";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-12BleXJQ7cS3c8IFz6PEg0MB/bJ6ZQR40dc5bK/FM/o=";
  };

  checkInputs = [ trio curio async-timeout ];

  meta = with lib; {
    description = "The python-socks package provides a core proxy client functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ vojta001 ];
  };
}
