{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "2.15.6";

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
    sha256 = "485ac6ed0dff5e1af6ea1e3a54425a448968f581b065424c89a5375e4d4866fd";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
