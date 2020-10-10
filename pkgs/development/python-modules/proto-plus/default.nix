{ stdenv
, buildPythonPackage
, fetchPypi
, protobuf
}:

buildPythonPackage rec {
  pname = "proto-plus";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n8ia51jg2dkab2sf0qnh39bssqhz65ybcqr78f3zzf7ja923lkr";
  };

  propagatedBuildInputs = [ protobuf ];

  meta = with stdenv.lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = [ maintainers.ruuda ];
  };
}
