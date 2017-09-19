{ stdenv, buildPythonPackage, fetchPypi, unittest2, six }:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "1.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02in5555iak50gzn35bnnha9s85idmh0wwxaxz13v81z5krn077d";
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
