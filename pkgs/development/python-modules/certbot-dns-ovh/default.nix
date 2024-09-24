{
  buildPythonPackage,
  acme,
  certbot,
  dns-lexicon,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "certbot-dns-ovh";
  format = "setuptools";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-ovh";

  propagatedBuildInputs = [
    acme
    certbot
    dns-lexicon
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-o cache_dir=$(mktemp -d)"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-W 'ignore:pkg_resources is deprecated as an API:DeprecationWarning'"
    "-W 'ignore:Package lexicon.providers is deprecated and will be removed in Lexicon 4>=.:DeprecationWarning'"
    "-W 'ignore:Legacy configuration object has been used to load the ConfigResolver.:DeprecationWarning'"
  ];

  meta = certbot.meta // {
    description = "OVH DNS Authenticator plugin for Certbot";
  };
}
