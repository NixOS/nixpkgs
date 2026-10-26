{
  buildPythonPackage,
  acme,
  certbot,
  google-api-python-client,
  google-auth,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "certbot-dns-google";
  inherit (certbot) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/certbot-dns-google";

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
})
