{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson, isPy27
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.8.0";
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
    sha256 = "47911dd7c641a27160f0df5fd0fe94667160ffe97f70a42c3cc18388d86098cc";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
