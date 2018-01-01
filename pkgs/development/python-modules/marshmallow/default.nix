{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  name = "${pname}-${version}";
  version = "2.13.6";

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
    sha256 = "e3e83f11cade65fc78482a7620f01f82080f032b5fb51756e396635ebc711c75";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
