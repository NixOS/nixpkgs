{ lib, buildPythonPackage, fetchPypi, mock, testscenarios, docutils, lockfile }:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57c84f50a04d7825515e4dbf3a31c70cc44414394a71608dee6cfde469e81766";
  };

  # A test fail within chroot builds.
  doCheck = false;

  buildInputs = [ mock testscenarios ];
  propagatedBuildInputs = [ docutils lockfile ];

  meta = with lib; {
    description = "Library to implement a well-behaved Unix daemon process";
    homepage = "https://pagure.io/python-daemon/";
    license = [ licenses.gpl3Plus licenses.asl20 ];
  };
}
