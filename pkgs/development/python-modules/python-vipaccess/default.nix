{ lib
, buildPythonPackage
, fetchPypi
, oath
, pycryptodome
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "python-vipaccess";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vBFCRXwZ91C48GuOet2Obbo7gM02M2c9+7rhp0l6w54=";
  };

  propagatedBuildInputs = [
    oath
    pycryptodome
    requests
  ];

  checkInputs = [ pytest ];
  # test_check_token_detects_valid_hotp_token,
  # test_check_token_detects_valid_totp_token and
  # test_check_token_detects_invlaid_token require network
  checkPhase = ''
    mv vipaccess vipaccess.hidden
    pytest tests/ -k 'not test_check_token'
  '';

  meta = with lib; {
    description = "A free software implementation of Symantec's VIP Access application and protocol";
    homepage = "https://github.com/dlenski/python-vipaccess";
    license = licenses.asl20;
    maintainers = with maintainers; [ aw ];
  };
}
