{
  buildPythonPackage,
  certbot,
  pyparsing,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certbot-nginx";
  pyproject = true;

  inherit (certbot) src version;

  sourceRoot = "${src.name}/certbot-nginx";

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
}
