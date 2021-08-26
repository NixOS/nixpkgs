{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "daemons";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cvyhrna1djpcjp957f46lpzgzxxpp4mhm12xhg8q3cf9pcv3nip";
  };

  # no tests available
  #doCheck = false;
  #pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Well behaved unix daemons for every occasion.";
    homepage    = "https://github.com/kevinconway/daemons";
    license     = licenses.asl20;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms   = platforms.unix;
  };
}
