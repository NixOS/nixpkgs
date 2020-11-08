{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson, isPy27
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.7.1";
  disabled = isPy27;

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
    sha256 = "a2a5eefb4b75a3b43f05be1cca0b6686adf56af7465c3ca629e5ad8d1e1fe13d";
  };

  requiredPythonModules = [ dateutil simplejson ];

  doCheck = false;
}
