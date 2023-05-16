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

<<<<<<< HEAD
  sourceRoot = "${src.name}/certbot-dns-cloudflare";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    acme
    certbot
    cloudflare
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

  sourceRoot = "source/certbot-dns-cloudflare";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = certbot.meta // {
    description = "Cloudflare DNS Authenticator plugin for Certbot";
  };
}
