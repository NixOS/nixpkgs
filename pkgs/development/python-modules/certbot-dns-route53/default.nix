{ buildPythonPackage
, acme
, boto3
, certbot
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certbot-dns-route53";
  format = "setuptools";

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

  pytestFlagsArray = [
    "-o cache_dir=$(mktemp -d)"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-W 'ignore:pkg_resources is deprecated as an API:DeprecationWarning'"

    # Monitor https://github.com/certbot/certbot/issues/9828 for a solution
    "-W 'ignore:X509Extension support in pyOpenSSL is deprecated:DeprecationWarning'"
  ];

  sourceRoot = "${src.name}/certbot-dns-route53";

  meta = certbot.meta // {
    description = "Route53 DNS Authenticator plugin for Certbot";
  };
}
