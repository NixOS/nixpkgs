{
  buildPythonPackage,
  certbot,
  cryptography,
  pyopenssl,
  pyrfc3339,
  josepy,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "acme";
  inherit (certbot) version src;
  pyproject = true;

  sourceRoot = "${src.name}/acme";

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    pyopenssl
    pyrfc3339
    pytz
    requests
    josepy
  ];

  # does not contain any tests
  doCheck = false;

  pythonImportsCheck = [ "acme" ];

  meta = certbot.meta // {
    description = "ACME protocol implementation in Python";
  };
}
