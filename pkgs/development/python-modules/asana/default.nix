{ lib, buildPythonPackage, fetchPypi,
  pytest, requests, requests_oauthlib, six
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.6.2";
  name = "${pname}-${version}";

  meta = {
    description = "Python client library for Asana";
    homepage = https://github.com/asana/python-asana;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0skai72392n3i1c4bl3hn2kh5lj990qsbasdwkbjdcy6vq57jggf";
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
