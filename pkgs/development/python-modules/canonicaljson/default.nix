{ stdenv, buildPythonPackage, fetchPypi
, frozendict, simplejson, six
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q50zk9a0r7kd56rdf9cgyxxj7vy54j96sgh8vc8jhmsvdv8dzh6";
  };

  propagatedBuildInputs = [
    frozendict simplejson six
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matrix-org/python-canonicaljson;
    description = "Encodes objects and arrays as RFC 7159 JSON.";
    license = licenses.asl20;
  };
}
