{ lib, buildPythonPackage, fetchPypi, mock, testscenarios, docutils, lockfile }:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "affeca9e5adfce2666a63890af9d6aff79f670f7511899edaddca7f96593cc25";
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
