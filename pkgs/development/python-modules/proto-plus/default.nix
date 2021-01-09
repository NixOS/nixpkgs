{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, protobuf
, googleapis_common_protos
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "proto-plus";
  version = "1.13.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i5jjnwpd288378h37zads08h695iwmhxm0sxbr3ln6aax97rdb1";
  };

  propagatedBuildInputs = [ protobuf ];

  checkInputs = [ pytestCheckHook pytz googleapis_common_protos ];

  pythonImportsCheck = [ "proto" ];

  meta = with stdenv.lib; {
    description = "Beautiful, idiomatic protocol buffers in Python";
    homepage = "https://github.com/googleapis/proto-plus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda SuperSandro2000 ];
  };
}
