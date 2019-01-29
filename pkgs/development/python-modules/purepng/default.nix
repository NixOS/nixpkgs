{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "purepng";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kcl7a6d7d59360fbz2jwfk6ha6pmqgn396962p4s62j893d2r0d";
  };

  meta = with stdenv.lib; {
    description = "Pure Python library for PNG image encoding/decoding";
    homepage    = https://github.com/scondo/purepng;
    license     = licenses.mit;
  };

}
