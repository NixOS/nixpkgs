{ lib
, fetchPypi
, buildPythonPackage
, acme
, certbot
}:

buildPythonPackage rec {
  pname = "certbot-dns-inwx";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v03QBHsxhl6R8YcwWIKD+pf4APy9S2vFcQe3ZEc6AjI=";
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
