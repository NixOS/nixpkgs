{ buildPythonPackage
, acme
, boto3
, certbot
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certbot-dns-route53";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    acme
    boto3
    certbot
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/certbot-dns-route53";

  meta = certbot.meta // {
    description = "Route53 DNS Authenticator plugin for Certbot";
  };
}
