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
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f148d4534e3a4dda9050a6a038868594c1216ea2413f2144ca6697e0e20c9cad";
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
