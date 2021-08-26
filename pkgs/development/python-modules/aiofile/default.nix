{ lib, fetchPypi, buildPythonPackage, caio }:

buildPythonPackage rec {
  pname = "aiofile";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hcjgx8bxhkc30i45w8qsbyp2pqzqsmci3aa69xf3fp3zjw3i3q6";
  };

  propagatedBuildInputs = [
    caio
  ];

  # no tests available
  #doCheck = false;
  #pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Real asynchronous file operations with asyncio support.";
    homepage    = "https://github.com/mosquito/aiofile";
    license     = licenses.asl20;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms   = platforms.unix;
  };
}
