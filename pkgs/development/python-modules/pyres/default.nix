{ lib, stdenv, fetchPypi, buildPythonPackage, fetchFromGitHub, simplejson, redis, setproctitle, nose, pkgs }:

buildPythonPackage rec {
  pname = "pyres";
  version = "1.5";

  propagatedBuildInputs = [ simplejson setproctitle redis pkgs.ps ];
  checkInputs = [ nose pkgs.redis ];

  # PyPI tarball doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "binarydud";
    repo = pname;
    rev = version;
    sha256 = "1rkpv7gbjxl9h9g7kncmsrgmi77l7pgfq8d7dbnsr3ia2jmjqb8y";
  };

  # started redis-server makes this hang on darwin
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    redis-server &
    nosetests . --exclude test_worker_pids
  '';

  meta = with lib; {
    description = "Python resque clone";
    homepage = "https://github.com/binarydud/pyres";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
    broken = true; # not compatible with latest redis
  };
}
