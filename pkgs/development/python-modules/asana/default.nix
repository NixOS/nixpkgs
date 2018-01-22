{ lib, buildPythonPackage, fetchPypi,
  pytest, requests, requests_oauthlib, six
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.6.7";
  name = "${pname}-${version}";

  meta = {
    description = "Python client library for Asana";
    homepage = https://github.com/asana/python-asana;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "d576601116764050c4cf63b417f1c24700b76cf6686f0e51e6b0b77d450e7973";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ requests requests_oauthlib six ];

  patchPhase = ''
    echo > requirements.txt
    sed -i "s/requests~=2.9.1/requests >=2.9.1/" setup.py
    sed -i "s/requests_oauthlib~=0.6.1/requests_oauthlib >=0.6.1/" setup.py
  '';

  # ERROR: file not found: tests
  doCheck = false; 

  checkPhase = ''
    py.test tests
  '';

}
