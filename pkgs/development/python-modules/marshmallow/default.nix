{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson, isPy27
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.3.0";
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
    sha256 = "0ba81b6da4ae69eb229b74b3c741ff13fe04fb899824377b1aff5aaa1a9fd46e";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
