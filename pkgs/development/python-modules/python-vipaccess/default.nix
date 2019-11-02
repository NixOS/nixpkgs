{ stdenv
, buildPythonPackage
, fetchPypi
, lxml
, oath
, pycryptodome
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "python-vipaccess";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m6b7qipiaj6pz86kjhyq5m5jxxijpk58gpsdkj5bn0wjl6x1pg2";
  };

  propagatedBuildInputs = [
    lxml
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

  meta = with stdenv.lib; {
    description = "A free software implementation of Symantec's VIP Access application and protocol";
    homepage = "https://github.com/dlenski/python-vipaccess";
    license = licenses.asl20;
    maintainers = with maintainers; [ aw ];
  };
}
