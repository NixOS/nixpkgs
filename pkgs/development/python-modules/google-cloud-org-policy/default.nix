{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, google-api-core, mock, proto-plus, protobuf, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ad50ce9145c3b477536752785635295c318b2b123bc9d251020cc1cfe98b131";
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
