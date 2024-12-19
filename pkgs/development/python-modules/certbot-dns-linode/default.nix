{
  buildPythonPackage,
  setuptools,
  acme,
  certbot,
  dns-lexicon,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "certbot-dns-linode";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-linode";

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    acme
    certbot
    dns-lexicon
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-o cache_dir=$(mktemp -d)"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "Linode DNS Authenticator plugin for Certbot";
  };
}
