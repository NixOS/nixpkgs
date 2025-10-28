{
  buildPythonPackage,
  acme,
  certbot,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-nginx";
  pyproject = true;

  inherit (certbot) src version;
  disabled = pythonOlder "3.9";

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
