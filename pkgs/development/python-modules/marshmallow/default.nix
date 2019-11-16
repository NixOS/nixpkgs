{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.2.1";

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
    sha256 = "9a2f3e8ea5f530a9664e882d7d04b58650f46190178b2264c72b7d20399d28f0";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
