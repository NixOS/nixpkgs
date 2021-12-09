{ pkgs
, buildPythonPackage
, fetchFromGitHub
, requests
, python
}:

buildPythonPackage rec {
  pname = "facebook-sdk";
  version = "3.1.0";

  src = fetchFromGitHub {
     owner = "pythonforfacebook";
     repo = "facebook-sdk";
     rev = "v3.1.0";
     sha256 = "0p7p0wvcspd9p8d6r25bgjbf0ihdw5g1jw3dylwngrazdmc3g36b";
  };

  propagatedBuildInputs = [ requests ];

  # checks require network
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} test/test_facebook.py
  '';

  meta = with pkgs.lib; {
    description = "Client library that supports the Facebook Graph API and the official Facebook JavaScript SDK";
    homepage = "https://github.com/pythonforfacebook/facebook-sdk";
    license = licenses.asl20 ;
    maintainers = [ maintainers.costrouc ];
  };
}
