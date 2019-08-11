{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "2.18.1";

  meta = {
    homepage = "https://github.com/marshmallow-code/marshmallow";
    description = ''
      A lightweight library for converting complex objects to and from
      simple Python datatypes.
    '';
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "6eeaf1301a5f5942bfe8ab2c2eaf03feb793072b56d5fae563638bddd7bb62e6";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
