{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  name = "${pname}-${version}";
  version = "2.15.0";

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
    sha256 = "d3f31fe7be2106b1d783cbd0765ef4e1c6615505514695f33082805f929dd584";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
