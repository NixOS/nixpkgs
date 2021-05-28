{ stdenv, buildPythonPackage, fetchPypi
, protobuf, pytest, setuptools }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.52.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "560716c807117394da12cecb0a54da5a451b5cf9866f1d37e9a5e2329a665351";
  };

  propagatedBuildInputs = [ protobuf setuptools ];
  checkInputs = [ pytest ];

  doCheck = false;  # there are no tests

  meta = with stdenv.lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
