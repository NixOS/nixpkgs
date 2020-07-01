{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson, isPy27
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.6.1";
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
    sha256 = "35ee2fb188f0bd9fc1cf9ac35e45fd394bd1c153cee430745a465ea435514bd5";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
