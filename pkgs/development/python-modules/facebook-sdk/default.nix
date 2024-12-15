{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  requests,
  python,
}:

buildPythonPackage rec {
  pname = "facebook-sdk";
  version = "3.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "138grz0n6plzdqgi4h6hhszf58bsvx9v76cwj51g1nd3kvkd5g6a";
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
    license = licenses.asl20;
    maintainers = [ ];
  };
}
