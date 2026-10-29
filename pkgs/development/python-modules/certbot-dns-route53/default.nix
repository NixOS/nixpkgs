{
  buildPythonPackage,
  acme,
  boto3,
  certbot,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "certbot-dns-route53";
  pyproject = true;

  inherit (certbot) src version;

  sourceRoot = "${finalAttrs.src.name}/certbot-dns-route53";

  build-system = [ setuptools ];

  dependencies = [
    acme
    boto3
    certbot
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-pno:cacheprovider"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-Wignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "Route53 DNS Authenticator plugin for Certbot";
  };
})
