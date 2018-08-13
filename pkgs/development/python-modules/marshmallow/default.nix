{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "2.15.4";

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
    sha256 = "0f3776aa5b5405f6000c9304841abe6d4d708bb08207fc89a5ecd86622ec9e54";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
