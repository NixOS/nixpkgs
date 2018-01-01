{ lib, buildPythonPackage, fetchPypi,
  pytest, requests, requests_oauthlib, six
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.6.5";
  name = "${pname}-${version}";

  meta = {
    description = "Python client library for Asana";
    homepage = https://github.com/asana/python-asana;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "eab8d24c2a4670b541b75da2f4bf5b995fe71559c1338da53ce9039f7b19c9a0";
  };

  buildInputs = [ pytest ];
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
