{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, google-api-core, mock, proto-plus, protobuf, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5489dffc6b6558125e548bc8c5be78f13d11bb9916470992816e6ed66a9d7fb";
  };

  propagatedBuildInputs = [ google-api-core proto-plus ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';
  checkInputs = [ mock protobuf pytest-asyncio pytestCheckHook ];
  pythonImportsCheck = [ "google.cloud.orgpolicy" ];

  meta = with lib; {
    description = "Protobufs for Google Cloud Organization Policy.";
    homepage = "https://github.com/googleapis/python-org-policy";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
  };
}
