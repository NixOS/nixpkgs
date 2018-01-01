{ lib
, buildPythonPackage
, fetchPypi
, cffi
, enum34
, construct
}:

buildPythonPackage rec {
  pname = "brotlipy";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10s2y19zywfkf3sksrw81czhva759aki0clld2pnnlgf64sz7016";
  };

  propagatedBuildInputs = [ cffi enum34 construct ];

  meta = {
    description = "Python bindings for the reference Brotli encoder/decoder";
    homepage = "https://github.com/python-hyper/brotlipy/";
    license = lib.licenses.mit;
  };
}