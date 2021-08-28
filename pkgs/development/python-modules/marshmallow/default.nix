{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson, isPy27
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.10.0";
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
    sha256 = "4ab2fdb7f36eb61c3665da67a7ce281c8900db08d72ba6bf0e695828253581f7";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
