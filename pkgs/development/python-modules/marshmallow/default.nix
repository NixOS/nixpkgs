{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson, isPy27
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.9.1";
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
    sha256 = "73facc37462dfc0b27f571bdaffbef7709e19f7a616beb3802ea425b07843f4e";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
