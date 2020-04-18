{ stdenv, buildPythonPackage, fetchPypi
, frozendict, simplejson, six
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45bce530ff5fd0ca93703f71bfb66de740a894a3b5dd6122398c6d8f18539725";
  };

  propagatedBuildInputs = [
    frozendict simplejson six
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/matrix-org/python-canonicaljson";
    description = "Encodes objects and arrays as RFC 7159 JSON.";
    license = licenses.asl20;
  };
}
