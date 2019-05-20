{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "627ec53fab43d06c1b5c950e217fa9819e169daf753111a7f244e94bf8fb3384";
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
