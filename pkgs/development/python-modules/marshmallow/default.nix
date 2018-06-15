{ lib, buildPythonPackage, fetchPypi,
  dateutil, simplejson
}:

buildPythonPackage rec {
  pname = "marshmallow";
  name = "${pname}-${version}";
  version = "2.15.3";

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
    sha256 = "171f409d48b44786b7df2793cbd7f1a9062f0fe2c14d547da536b5010f671ade";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  doCheck = false;
}
