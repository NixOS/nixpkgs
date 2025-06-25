{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  acme,
  certbot,
  inwx-domrobot,
}:

buildPythonPackage rec {
  pname = "certbot-dns-inwx";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oGGy990";
    repo = "certbot-dns-inwx";
    tag = "v${version}";
    hash = "sha256-x4wDg36J9MvXXHBxUMCoHO3p6c3FKBBB879CpxG/1NA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    acme
    certbot
    inwx-domrobot
  ];

  # Doesn't have any tests
  doCheck = false;

  pythonImportsCheck = [ "certbot_dns_inwx" ];

  meta = {
    description = "INWX DNS Authenticator plugin for Certbot";
    homepage = "https://github.com/oGGy990/certbot-dns-inwx";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ onny ];
  };
}
