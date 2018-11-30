{ lib, buildPythonPackage, fetchPypi, mock, testscenarios, docutils, lockfile }:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aca149ebf7e73f10cd554b2df5c95295d49add8666348eff6195053ec307728c";
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
