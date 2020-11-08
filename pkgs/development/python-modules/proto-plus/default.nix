{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, protobuf
, google_api_core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "proto-plus";
  version = "1.10.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cee328fc3da159ebbbdf15da6fb0b3bfe79ca32b075d208ff2a033854f6b324a";
  };

  requiredPythonModules = [ protobuf ];

  checkInputs = [ pytestCheckHook google_api_core ];

  meta = with stdenv.lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = [ maintainers.ruuda ];
  };
}
