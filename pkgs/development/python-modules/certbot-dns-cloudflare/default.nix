{ buildPythonPackage
, acme
, certbot
, cloudflare
, isPy3k
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "certbot-dns-cloudflare";

  propagatedBuildInputs = [
    acme
    certbot
    cloudflare
  ];

  checkInputs = [
    pytest
    pytestCheckHook
  ];

  disabled = !isPy3k;

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/${pname}";

  meta = certbot.meta // {
    description = "Cloudflare DNS Authenticator plugin for Certbot";
  };
}
