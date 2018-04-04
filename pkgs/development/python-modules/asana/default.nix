{ lib, buildPythonPackage, pytest, requests, requests_oauthlib, six
, fetchFromGitHub, responses, stdenv
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.7.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    rev = "v${version}";
    sha256 = "0786y3wxqxxhsb0kkpx4bfzif3dhvv3dmm6vnq58iyj94862kpxf";
  };

  checkInputs = [ pytest responses ];
  propagatedBuildInputs = [ requests requests_oauthlib six ];

  patchPhase = ''
    echo > requirements.txt
    sed -i "s/requests~=2.9.1/requests >=2.9.1/" setup.py
    sed -i "s/requests_oauthlib~=0.6.1/requests_oauthlib >=0.6.1/" setup.py
  '';

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Python client library for Asana";
    homepage = https://github.com/asana/python-asana;
    license = licenses.mit;
  };
}
