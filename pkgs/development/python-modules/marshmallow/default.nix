{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "2.18.0";

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
    sha256 = "958e6640bec9a04ca15701e3d99b12c4269d0f43be596f00eeca1f2baf530abc";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
