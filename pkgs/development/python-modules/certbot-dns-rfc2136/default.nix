{
  buildPythonPackage,
  acme,
  certbot,
  dnspython,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "certbot-dns-rfc2136";
  format = "setuptools";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-rfc2136";

  propagatedBuildInputs = [
    acme
    certbot
    dnspython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-p no:cacheprovider"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "RFC 2136 DNS Authenticator plugin for Certbot";
  };
}
