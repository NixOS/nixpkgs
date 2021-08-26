{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h3a7agljnkrg4aaia3rwz58mxgzl5mcdb68r75avfmq130b0iif";
  };

  # no tests available
  #doCheck = false;
  #pythonImportsCheck = [ "" ];

  meta = with lib; {
    description = "Asynchronous file IO for Linux POSIX and Windows.";
    homepage    = "https://github.com/mosquito/caio";
    license     = licenses.asl20;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms   = platforms.unix;
  };
}
