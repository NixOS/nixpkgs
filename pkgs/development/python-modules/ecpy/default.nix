{ stdenv, fetchPypi, buildPythonPackage, isPy3k, hidapi
, pycrypto, pillow, protobuf, future
}:

buildPythonPackage rec {
  pname = "ECPy";
  version = "0.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef41346ae24789699f3bc3ddefbfac03ad6b73b7d3d19b998ba9ce47b67c7277";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ];

  meta = with stdenv.lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = https://github.com/ubinity/ECPy;
    license = licenses.asl20;
  };
}
