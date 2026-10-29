{
  buildPythonPackage,
  certbot,
  pyparsing,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "certbot-nginx";
  pyproject = true;

  inherit (certbot) src version;

  sourceRoot = "${finalAttrs.src.name}/certbot-nginx";

  build-system = [ setuptools ];

  dependencies = [
    certbot
    pyparsing
  ];

  pythonImportsCheck = [
    "certbot_nginx"
    "certbot.plugins.nginx"
  ];

  meta = certbot.meta // {
    description = "Nginx plugin for Certbot";
  };
})
