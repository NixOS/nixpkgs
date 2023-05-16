{ buildPythonPackage
, acme
, certbot
, dnspython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certbot-dns-rfc2136";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

<<<<<<< HEAD
  sourceRoot = "${src.name}/certbot-dns-rfc2136";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    acme
    certbot
    dnspython
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pytestFlagsArray = [
    "-o cache_dir=$(mktemp -d)"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-W 'ignore:pkg_resources is deprecated as an API:DeprecationWarning'"
  ];
=======
  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/certbot-dns-rfc2136";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = certbot.meta // {
    description = "RFC 2136 DNS Authenticator plugin for Certbot";
  };
}
