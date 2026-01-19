{
  buildPythonPackage,
  acme,
  certbot,
  pyparsing,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-nginx";
  pyproject = true;

  inherit (certbot) src version;

  sourceRoot = "${src.name}/certbot-nginx";

  build-system = [ setuptools ];

  dependencies = [
    acme
    certbot
    pyparsing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-pno:cacheprovider"
  ];

  meta = certbot.meta // {
    description = "Nginx plugin for Certbot";
  };
}
