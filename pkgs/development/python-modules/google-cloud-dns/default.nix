{ lib
, buildPythonPackage
, fetchFromGitHub
, google-api-core
, google-cloud-core
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dns";
  version = "0.34.0";

  src = fetchFromGitHub {
     owner = "googleapis";
     repo = "python-dns";
     rev = "v0.34.0";
     sha256 = "1sq9ny38zsn5gdydac6rn2f7761zyy6nn9fyrzcrm3jm1lbv263g";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core ];

  checkInputs = [ mock pytestCheckHook ];

  preCheck = ''
    # don#t shadow python imports
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_quota"
  ];

  pythonImportsCheck = [ "google.cloud.dns" ];

  meta = with lib; {
    description = "Google Cloud DNS API client library";
    homepage = "https://github.com/googleapis/python-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
