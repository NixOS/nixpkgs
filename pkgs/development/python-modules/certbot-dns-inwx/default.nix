{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  acme,
  certbot,
}:

buildPythonPackage rec {
  pname = "certbot-dns-inwx";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oGGy990";
    repo = "certbot-dns-inwx";
    tag = "v${version}";
    hash = "sha256-9dDSJcXlPq065CloaszwutUXsGn+Y9fIeTiGmiXGonY=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    acme
    certbot
  ];

  # Doesn't have any tests
  doCheck = false;

  pytestImportsCheck = [ "certbot_dns_inwx" ];

  meta = with lib; {
    description = "INWX DNS Authenticator plugin for Certbot";
    homepage = "https://github.com/oGGy990/certbot-dns-inwx";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ onny ];
  };
}
