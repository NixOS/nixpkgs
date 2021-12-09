{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "daemonize";
  version = "2.5.0";

  src = fetchFromGitHub {
     owner = "thesharp";
     repo = "daemonize";
     rev = "v2.5.0";
     sha256 = "0pz914x6dfq133nfv0y8q8fss4zr52ip8mq3ds50rx0ddlbb0k2x";
  };

  meta = with lib; {
    description = "Library to enable your code run as a daemon process on Unix-like systems";
    homepage = "https://github.com/thesharp/daemonize";
    license = licenses.mit;
  };

}
