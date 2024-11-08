{
  buildPythonPackage,
  acme,
  certbot,
  google-api-python-client,
  oauth2client,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "certbot-dns-google";
  format = "setuptools";

  inherit (certbot) src version;
  disabled = pythonOlder "3.6";

  sourceRoot = "${src.name}/certbot-dns-google";

  propagatedBuildInputs = [
    acme
    certbot
    google-api-python-client
    oauth2client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-o cache_dir=$(mktemp -d)"
    # https://github.com/certbot/certbot/issues/9988
    "-Wignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "Google Cloud DNS Authenticator plugin for Certbot";
  };
}
