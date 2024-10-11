{
  buildPythonPackage,
  pythonPackages,
  setuptools,
  acme,
  certbot,
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

  propagatedBuildInputs = [
    acme
    certbot
    pythonPackages.dns-lexicon
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  meta = certbot.meta // {
    description = "Linode DNS Authenticator plugin for Certbot";
  };
}
