{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ECPy";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ab60sx4bbsmccwmdvz1023r0cbzi4phar4ipzn5npdj5gw1ny4l";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ];

  meta = with stdenv.lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = https://github.com/ubinity/ECPy;
    license = licenses.asl20;
  };
}
