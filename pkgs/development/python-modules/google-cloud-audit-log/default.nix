{
  lib,
  buildPythonPackage,
  fetchPypi,
  googleapis-common-protos,
  protobuf,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-cloud-audit-log";
  version = "0.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-huL6ujODrcj9BKW9f9T5YLPkrtqn7ZUPL4kc4WkC62s=";
  };

  propagatedBuildInputs = [
    googleapis-common-protos
    protobuf
  ];

  # tests are a bit wonky to setup and are not very deep either
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.audit" ];

  meta = with lib; {
    description = "Google Cloud Audit Protos";
    homepage = "https://github.com/googleapis/python-audit-log";
    changelog = "https://github.com/googleapis/python-audit-log/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
