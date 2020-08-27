{ stdenv, buildPythonPackage, fetchPypi
, frozendict, simplejson, six, isPy27
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4763db06a2e8553293c5edaa4bda05605c3307179a7ddfb30273a24ac384b6c";
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
