{
  lib,
  buildPythonPackage,
  fetchPypi,
  acme,
  certbot,
  setuptools,
  requests,
  pytz,
}:

buildPythonPackage rec {
  pname = "certbot-dns-wedos";
  version = "2.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "certbot_dns_wedos";
    hash = "sha256-Sle3hoBLwVPF30caCyYtt3raY5Gs9ekg0DthvHxvB4E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certbot
    acme
    requests
    pytz
  ];

  pythonImportsCheck = [ "certbot_dns_wedos" ];

  meta = {
    description = "Wedos DNS Authenticator plugin for Certbot";
    homepage = "https://github.com/clazzor/certbot-dns-wedos";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tsandrini ];
  };
}
