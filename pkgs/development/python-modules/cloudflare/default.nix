{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, requests
, future
, pyyaml
, jsonlines
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "2.8.15";

  src = fetchFromGitHub {
     owner = "cloudflare";
     repo = "python-cloudflare";
     rev = "2.8.15";
     sha256 = "1ygh3xh3b6600v17jfagjjxkzn6jsmrm51p1lifanl4rq4p927pr";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    requests
    future
    pyyaml
    jsonlines
  ];

  # no tests associated with package
  doCheck = false;
  pythonImportsCheck = [ "CloudFlare" ];

  meta = with lib; {
    description = "Python wrapper for the Cloudflare v4 API";
    homepage = "https://github.com/cloudflare/python-cloudflare";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
