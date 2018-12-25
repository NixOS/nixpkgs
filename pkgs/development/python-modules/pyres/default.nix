{ stdenv, fetchPypi, buildPythonPackage, fetchFromGitHub, simplejson, redis, setproctitle, nose, pkgs }:

let

  # the requirements of `pyres` support Redis 3.x (due to a missing upper-bound),
  # but it doesn't support Redis 3.x.
  redis' = redis.overridePythonAttrs (old: rec {
    pname = "redis";
    version = "2.10.6";
    src = fetchPypi {
      inherit pname version;
      sha256 = "03vcgklykny0g0wpvqmy8p6azi2s078317wgb2xjv5m2rs9sjb52";
    };
  });

in

buildPythonPackage rec {
  pname = "pyres";
  version = "1.5";

  # ps is used in Worker.worker_pids method
  propagatedBuildInputs = [ simplejson setproctitle redis' pkgs.ps ];
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
