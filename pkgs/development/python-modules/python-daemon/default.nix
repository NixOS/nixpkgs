{ lib, buildPythonPackage, fetchPypi, mock, testscenarios, docutils, lockfile }:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "261c859be5c12ae7d4286dc6951e87e9e1a70a882a8b41fd926efc1ec4214f73";
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
