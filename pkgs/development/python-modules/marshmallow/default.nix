{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.2.2";

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
    sha256 = "1a358beb89c2b4d5555272065a9533591a3eb02f1b854f3c4002d88d8f2a1ddb";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
