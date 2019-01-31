{ lib, buildPythonPackage, fetchFromGitHub
, isodate, requests, requests_oauthlib }:

buildPythonPackage rec {
  pname = "msrest";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "${pname}-for-python";
    rev = "v${version}";
    sha256 = "0ilrc06qq0dw4qqzq1dq2vs6nymc39h19w52dwcyawwfalalnjzi";
  };

  propagatedBuildInputs = [ isodate requests requests_oauthlib ];

  # TypeError: async_poller() missing 4 required positional arguments: 'client',
  # 'initial_response', 'deserialization_callback', and 'polling_method'
  doCheck = false;

  meta = with lib; {
    description = "Microsoft wrapper around requests";
    homepage = https://github.com/Azure/msrest-for-python;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.mit;
  };
}
