{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6de6de98e895f4266caefa768778533bdea98abbead6972d35c8a0f57409eea2";
  };

  propagatedBuildInputs = [ protobuf ];
  checkInputs = [ pytest ];

  doCheck = false;  # there are no tests

  meta = with stdenv.lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
