{ stdenv, buildPythonPackage, fetchPypi
, frozendict, simplejson, six, isPy27
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "899b7604f5a6a8a92109115d9250142cdf0b1dfdcb62cdb21d8fb5bf37780631";
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
