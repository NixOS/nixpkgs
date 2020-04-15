{ stdenv
, buildPythonPackage
, fetchPypi
, grpcio
, googleapis_common_protos
, pytest
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bfb5b56f648f457021a91c0df0db4934b6e0c300bd0f2de2333383fe958aa72";
  };

  propagatedBuildInputs = [ grpcio googleapis_common_protos ];

  # non-standard test format, and python3 will load local google folder first
  # but tests cannot be ran if google folder is removed or moved
  doCheck = false;
  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "GRPC library for the google-iam-v1 service";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
