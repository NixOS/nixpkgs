{ buildPythonPackage
, acme
, boto3
, certbot
, isPy3k
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "certbot-dns-route53";

  propagatedBuildInputs = [
    acme
    boto3
    certbot
  ];

  checkInputs = [
    pytest
    pytestCheckHook
  ];

  disabled = !isPy3k;

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/${pname}";

  meta = certbot.meta // {
    description = "Route53 DNS Authenticator plugin for Certbot";
  };
}
