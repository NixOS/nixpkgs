{ stdenv, buildPythonPackage, fetchPypi, unittest2, six }:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zw8bijlcmqrigsqvzj7gwh3qbd33dmpi9ij6h56b41x0dpm957d";
  };

  propagatedBuildInputs = [ unittest2 six ];

  # package supports 3.x but tests require egenix-mx-base which is python 2.x only
  # and is not currently in nixos
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python packages and modules used by Logilab ";
    homepage = https://www.logilab.org/project/logilab-common;
    license = licenses.lgpl21;
  };
}
