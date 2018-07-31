{ stdenv, buildPythonPackage, fetchPypi, unittest2, six }:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdda9ed0deca7c68f87f7a404ad742e47aaa1ca5956d12988236a5ec3bda13a0";
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
