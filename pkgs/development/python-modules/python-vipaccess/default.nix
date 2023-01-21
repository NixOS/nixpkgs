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
  version = "0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5013d306e5891ecfe523c9ef52d074fe8b6ca29ee259c0deeb8a83ae9884ce0";
  };

  propagatedBuildInputs = [
    oath
    pycryptodome
    requests
  ];

  nativeCheckInputs = [ pytest ];
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
