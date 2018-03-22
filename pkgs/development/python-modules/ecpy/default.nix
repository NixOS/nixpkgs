{ stdenv, fetchPypi, buildPythonPackage, isPy3k, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  pname = "ECPy";
  version = "0.8.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef3d95419d53368f52fb7d4b883b8df0dfc2dd19a76243422d24981c3e5f27bd";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ];

  meta = with stdenv.lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = https://github.com/ubinity/ECPy;
    license = licenses.asl20;
  };
}
