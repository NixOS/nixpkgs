{ pkgs
, buildPythonPackage
, fetchPypi
, requests
, python
}:

buildPythonPackage rec {
  pname = "facebook-sdk";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3d450ec313b62d3716fadc4e5098183760e1d2a9e0434a94b74e59ea6ea3e4d";
  };

  propagatedBuildInputs = [ requests ];

  # checks require network
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} test/test_facebook.py
  '';

  meta = with pkgs.lib; {
    description = "Client library that supports the Facebook Graph API and the official Facebook JavaScript SDK";
    homepage = https://github.com/pythonforfacebook/facebook-sdk;
    license = licenses.asl20 ;
    maintainers = [ maintainers.costrouc ];
  };
}
