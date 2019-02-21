{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d56ca712f67fff216d3be9eeeb8360ca59066d0365ba70b137b9e1801813747e";
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
