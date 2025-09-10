{
  acme,
  buildPythonPackage,
  certbot,
  dns-lexicon,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-dns-ovh";
  pyproject = true;

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-ovh";

  build-system = [ setuptools ];

  dependencies = [
    acme
    certbot
    dns-lexicon
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-pno:cacheprovider"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-Wignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "OVH DNS Authenticator plugin for Certbot";
  };
}
