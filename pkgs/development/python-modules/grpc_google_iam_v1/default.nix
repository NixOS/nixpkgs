{ stdenv
, buildPythonPackage
, fetchPypi
, grpcio
, googleapis_common_protos
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bfb5b56f648f457021a91c0df0db4934b6e0c300bd0f2de2333383fe958aa72";
  };

  propagatedBuildInputs = [ grpcio googleapis_common_protos ];

  meta = with stdenv.lib; {
    description = "GRPC library for the google-iam-v1 service";
    homepage = https://github.com/googleapis/googleapis;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
