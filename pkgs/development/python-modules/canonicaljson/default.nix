{ stdenv, buildPythonPackage, fetchPypi
, frozendict, simplejson, six, isPy27
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c86g0vvzdcg3nrcsqnbzlfhpprc2i894p8i14hska56yl27d6w9";
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
