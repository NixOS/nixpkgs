{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0946967c4c29b1339bb211949e1e17dbe0ae9ff8265fafa7bf4cf2164ef5a3b1";
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
