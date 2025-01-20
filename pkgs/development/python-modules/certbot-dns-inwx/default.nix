{
  lib,
  fetchPypi,
  buildPythonPackage,
  acme,
  certbot,
}:

buildPythonPackage rec {
  pname = "certbot-dns-inwx";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZT3KIB3GNRp3vMWJ4Vf5scKjEWfvnv73bmG15L+QWfg=";
  };

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
