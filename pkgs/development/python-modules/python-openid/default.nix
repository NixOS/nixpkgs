{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, nose
}:

buildPythonPackage rec {
  pname = "python-openid";
  version = "2.2.5";
  disabled = !isPy27;

  src = fetchFromGitHub {
    owner = "openid";
    repo = pname;
    rev = version;
    sha256 = "198800ka2xyjz4yi2zm23l2a0knmqzxb4wj1nhqps70jz8mwg5mz";
  };

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  # most tests require network access
  doCheck = false;

  meta = with lib; {
    description = "OpenID support for servers and consumers";
    homepage = https://github.com/openid/python-openid;
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };

}
