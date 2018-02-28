{ lib, buildPythonPackage, fetchPypi, mock, testscenarios, docutils, lockfile }:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17v80qb98p1gv4j9mq6wb55cv7hc4j1hzw5y2f4s5hrpxs3w3a2q";
  };

  # A test fail within chroot builds.
  doCheck = false;

  buildInputs = [ mock testscenarios ];
  propagatedBuildInputs = [ docutils lockfile ];

  meta = with lib; {
    description = "Library to implement a well-behaved Unix daemon process";
    homepage = https://alioth.debian.org/projects/python-daemon/;
    license = [ licenses.gpl3Plus licenses.asl20 ];
  };
}
