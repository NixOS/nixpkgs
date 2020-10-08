{ buildPythonPackage
, acme
, certbot
, dnspython
, isPy3k
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  inherit (certbot) src version;

  pname = "certbot-dns-rfc2136";

  propagatedBuildInputs = [
    acme
    certbot
    dnspython
  ];

  checkInputs = [
    pytest
    pytestCheckHook
  ];

  disabled = !isPy3k;

  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/${pname}";

  meta = certbot.meta // {
    description = "RFC 2136 DNS Authenticator plugin for Certbot";
  };
}
