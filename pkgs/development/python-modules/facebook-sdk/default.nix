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
    hash = "sha256-yrzS5p6j2fBCkZyZs1PfeqHivobQQBIfbp9eY8HPD40=";
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
