{ buildPythonPackage
, acme
, certbot
, google-api-python-client
, oauth2client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certbot-dns-google";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    acme
    certbot
    google-api-python-client
    oauth2client
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/certbot-dns-google";

  meta = certbot.meta // {
    description = "Google Cloud DNS Authenticator plugin for Certbot";
  };
}
