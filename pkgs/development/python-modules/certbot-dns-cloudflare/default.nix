{
  buildPythonPackage,
  acme,
  certbot,
  cloudflare,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-dns-cloudflare";
  pyproject = true;

  inherit (certbot) src version;
  disabled = pythonOlder "3.9";

  sourceRoot = "${src.name}/certbot-dns-cloudflare";

  build-system = [ setuptools ];

  dependencies = [
    acme
    certbot
    cloudflare
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-pno:cacheprovider"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-Wignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "Cloudflare DNS Authenticator plugin for Certbot";
    # https://github.com/certbot/certbot/pull/10182
    broken = true;
  };
}
