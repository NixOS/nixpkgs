{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  name = "${pname}-${version}";
  version = "2.13.5";

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
    sha256 = "048rzdkvnais51xdiy27nail5vxjb4ggw3vd60prn1q11lf16wig";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
