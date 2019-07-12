{ buildPythonPackage, fetchFromGitHub, lib, requests
, nose, mock, pycrypto
}:

buildPythonPackage rec {
  pname = "rauth";
  version = "0.7.2";

  # No tests in Pypi distribution
  src = fetchFromGitHub {
    owner = "litl";
    repo = "rauth";
    rev = version;
    sha256 = "1bhxc2ys89k271fnq9caxw9hnzz37k4z4k5276hzh4a22rprj4n1";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ nose mock pycrypto ];
  # work around module 'Crypto.PublicKey.RSA' has no attribute '_RSAobj'
  checkPhase = "nosetests -e rsasha1";

  meta = with lib; {
    description = "A Python library for OAuth 1.0/a, 2.0, and Ofly";
    license = licenses.mit;
    homepage = https://rauth.readthedocs.io/;
    maintainers = with maintainers; [ mredaelli ];
  };

}
