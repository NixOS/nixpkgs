{ lib, fetchPypi, buildPythonPackage, boto3 }:

buildPythonPackage rec {
  pname = "localstack-client";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "120iyayqz6r9ahdr2gd7h7kyzlw4n8fjr63h95gqm5p46vjpf80w";
  };

  buildInputs = [ boto3 ];

  doCheck = false;

  meta = {
    homepage = https://github.com/localstack/localstack-python-client;
    description = "python client for localstack";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.asl20;
  };
}
