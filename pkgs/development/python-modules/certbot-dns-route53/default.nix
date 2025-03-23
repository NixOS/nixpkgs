{
  buildPythonPackage,
  acme,
  boto3,
  certbot,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-dns-route53";
  pyproject = true;

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-route53";

  build-system = [ setuptools ];

  dependencies = [
    acme
    boto3
    certbot
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-p no:cacheprovider"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "Route53 DNS Authenticator plugin for Certbot";
  };
}
