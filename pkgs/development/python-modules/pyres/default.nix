{ stdenv, buildPythonPackage, fetchFromGitHub, simplejson, redis, setproctitle, nose, pkgs }:

buildPythonPackage rec {
  pname = "pyres";
  version = "1.5";

  # ps is used in Worker.worker_pids method
  propagatedBuildInputs = [ simplejson setproctitle redis pkgs.ps ];
  checkInputs = [ nose pkgs.redis ];

  # PyPI tarball doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "binarydud";
    repo = pname;
    rev = version;
    sha256 = "1rkpv7gbjxl9h9g7kncmsrgmi77l7pgfq8d7dbnsr3ia2jmjqb8y";
  };

  checkPhase = ''
    redis-server &
    nosetests .
  '';

  meta = with stdenv.lib; {
    description = "Python resque clone";
    homepage = https://github.com/binarydud/pyres;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
