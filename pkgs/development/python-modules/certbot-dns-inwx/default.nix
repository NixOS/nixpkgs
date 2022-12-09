{ lib
, fetchPypi
, buildPythonPackage
, acme
, certbot
}:

buildPythonPackage rec {
  pname = "certbot-dns-inwx";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yAgualY4J92pJ8PIkICg8w0eYHmT5L3qAUOCW/cAitw=";
  };

  propagatedBuildInputs = [
    acme
    certbot
  ];

  # Doesn't have any tests
  doCheck = false;

  pytestCheckHook = [ "certbot_dns_inwx" ];

  meta = with lib; {
    description = "INWX DNS Authenticator plugin for Certbot";
    homepage = "https://github.com/oGGy990/certbot-dns-inwx";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ onny ];
  };
}
