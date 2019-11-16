{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest, setuptools }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e61b8ed5e36b976b487c6e7b15f31bb10c7a0ca7bd5c0e837f4afab64b53a0c6";
  };

  propagatedBuildInputs = [ protobuf setuptools ];
  checkInputs = [ pytest ];

  doCheck = false;  # there are no tests

  meta = with stdenv.lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
