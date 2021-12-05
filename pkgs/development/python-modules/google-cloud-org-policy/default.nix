{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, google-api-core, mock
, proto-plus, protobuf, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdb2d6878c426ed34af8950b052845a76b0f5fab3f96a2ec5dc80be994ca5cf8";
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
