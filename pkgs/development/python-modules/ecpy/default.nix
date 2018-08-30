{ stdenv, fetchPypi, buildPythonPackage, isPy3k, hidapi
, pycrypto, pillow, protobuf, future
}:

buildPythonPackage rec {
  pname = "ECPy";
  version = "0.9.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0df66be67f3de0152dfb3c453f4247bdfa2b4e37aa75b98617a637376032229";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ];

  meta = with stdenv.lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = https://github.com/ubinity/ECPy;
    license = licenses.asl20;
  };
}
