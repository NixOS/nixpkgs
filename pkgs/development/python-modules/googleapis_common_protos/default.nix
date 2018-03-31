{ stdenv, buildPythonPackage, fetchPypi
, protobuf3_5, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1whfjl44gy15ha6palpwa2m0xi36dsvpaz8vw0cvb2k2lbdfsxf0";
  };

  propagatedBuildInputs = [ protobuf3_5 ];
  checkInputs = [ pytest ];

  doCheck = false;  # there are no tests

  meta = with stdenv.lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
