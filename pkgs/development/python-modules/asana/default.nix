{ lib, buildPythonPackage, fetchPypi,
  pytest, requests, requests_oauthlib, six
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.7.0";
  name = "${pname}-${version}";

  meta = {
    description = "Python client library for Asana";
    homepage = https://github.com/asana/python-asana;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7ff4a78529257a5412e78cafd6b3025523364c0ab628d579f2771dd66b254bc";
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
