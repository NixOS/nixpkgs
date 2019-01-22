{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "2.16.3";

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
    sha256 = "e1b79eb3b815b49918c64114dda691b8767b48a1f66dd1d8c0cd5842b74257c2";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
