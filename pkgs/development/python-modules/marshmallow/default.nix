{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  name = "${pname}-${version}";
  version = "2.15.1";

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
    sha256 = "b73361eab812af97eaf8e8691333a1096787968450051d132c8b9fb90aa1db5a";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
