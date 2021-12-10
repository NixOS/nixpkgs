{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, google-api-core, mock, proto-plus, protobuf, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "1.2.1";

  src = fetchFromGitHub {
     owner = "googleapis";
     repo = "python-org-policy";
     rev = "v1.2.1";
     sha256 = "0iz2mmxah4610kq58hvvgqnxn2bnslm9ph3bar7mxgfhwr87zdry";
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
