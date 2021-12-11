{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "homeconnect";
  version = "0.6.3";

  src = fetchFromGitHub {
     owner = "DavidMStraub";
     repo = "homeconnect";
     rev = "v0.6.3";
     sha256 = "122nhng2drjz280zq9j4fpc3wz647xynfzlqwzwadbk0rq91zxm4";
  };

  propagatedBuildInputs = [
    requests
    requests_oauthlib
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "homeconnect" ];

  meta = with lib; {
    description = "Python client for the BSH Home Connect REST API";
    homepage = "https://github.com/DavidMStraub/homeconnect";
    changelog = "https://github.com/DavidMStraub/homeconnect/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
