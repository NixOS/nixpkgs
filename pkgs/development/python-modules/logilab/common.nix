{ stdenv, buildPythonPackage, fetchPypi, isPy27, unittest2, six }:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "1.5.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n20znamai7jksimbdshy03rgw235qwa9vbx3lyajzwysblq4s4d";
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
