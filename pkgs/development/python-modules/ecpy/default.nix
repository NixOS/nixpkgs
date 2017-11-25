{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ECPy";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0509a90714448ef47ef727cb7aee3415995c883c945e972521b5838fa4c50e24";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ];

  meta = with stdenv.lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = https://github.com/ubinity/ECPy;
    license = licenses.asl20;
  };
}
