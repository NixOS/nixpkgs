{ stdenv
, buildPythonPackage
, fetchPypi
, grpc
, protobuf
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.52.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lakcsd35qm5x4visvw6z5f1niasv9a0mjyf2bd98wqi0z41c1sn";
  };

  propagatedBuildInputs = [ grpc protobuf ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "google.api"
    "google.logging"
    "google.longrunning"
    "google.rpc"
    "google.type"
  ];

  meta = with stdenv.lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/python-api-common-protos";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
