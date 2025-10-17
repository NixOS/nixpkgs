{
  buildPythonPackage,
  acme,
  certbot,
  google-api-python-client,
  google-auth,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-dns-google";
  inherit (certbot) src version;
  pyproject = true;

  sourceRoot = "${src.name}/certbot-dns-google";

  build-system = [ setuptools ];

  dependencies = [
    acme
    certbot
    google-api-python-client
    google-auth
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-pno:cacheprovider"
  ];

  meta = certbot.meta // {
    description = "Google Cloud DNS Authenticator plugin for Certbot";
  };
}
