{ pkgs
, buildPythonPackage
, fetchPypi
, requests
, python
}:

buildPythonPackage rec {
  pname = "facebook-sdk";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dx39krafb6cdnd7h5vgwmw4y075s6k3d31a6vhwvqhmdig3294h";
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
