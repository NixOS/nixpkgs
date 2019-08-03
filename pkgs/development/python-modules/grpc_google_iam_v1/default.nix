{ stdenv
, buildPythonPackage
, fetchPypi
, grpcio
, googleapis_common_protos
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5009e831dcec22f3ff00e89405249d6a838d1449a46ac8224907aa5b0e0b1aec";
  };

  propagatedBuildInputs = [ grpcio googleapis_common_protos ];

  meta = with stdenv.lib; {
    description = "GRPC library for the google-iam-v1 service";
    homepage = https://github.com/googleapis/googleapis;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
