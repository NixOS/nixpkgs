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
  version = "1.11.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "416a0f13987789333cd8760a0ee998f8eccd6d7165ee9f283d64ca2de3e8774d";
  };

  propagatedBuildInputs = [ protobuf ];

  checkInputs = [ pytestCheckHook google_api_core ];

  meta = with stdenv.lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = [ maintainers.ruuda ];
  };
}
