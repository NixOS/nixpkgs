{ stdenv, buildPythonPackage, fetchPypi
, frozendict, simplejson, six, isPy27
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v2b72n28fi763xxv9vrf4qc61anl2ys9njy7hlm719fdaq3sxml";
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
