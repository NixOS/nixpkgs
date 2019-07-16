{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.5.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d564872083af40bbcc7091340f17db778a316525c7c76497d58d11b98ca2aa74";
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
