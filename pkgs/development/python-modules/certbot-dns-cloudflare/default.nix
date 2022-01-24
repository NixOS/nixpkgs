{ buildPythonPackage
, acme
, certbot
, cloudflare
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certbot-dns-cloudflare";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    acme
    certbot
    cloudflare
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/certbot-dns-cloudflare";

  meta = certbot.meta // {
    description = "Cloudflare DNS Authenticator plugin for Certbot";
  };
}
