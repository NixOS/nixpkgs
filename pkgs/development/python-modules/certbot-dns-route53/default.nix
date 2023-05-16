{ buildPythonPackage
, acme
, boto3
, certbot
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certbot-dns-route53";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    acme
    boto3
    certbot
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

  sourceRoot = "${src.name}/certbot-dns-route53";
=======
  pytestFlagsArray = [ "-o cache_dir=$(mktemp -d)" ];

  sourceRoot = "source/certbot-dns-route53";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = certbot.meta // {
    description = "Route53 DNS Authenticator plugin for Certbot";
  };
}
