{ buildPythonPackage, pytest, requests, requests_oauthlib, six
, fetchFromGitHub, responses, stdenv
}:

buildPythonPackage rec {
  pname = "asana";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    rev = "v${version}";
    sha256 = "0vmpy4j1n54gkkg0l8bhw0xf4yby5kqzxnsv07cjc2w38snj5vy1";
  };

  checkInputs = [ pytest responses ];
  propagatedBuildInputs = [ requests requests_oauthlib six ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "requests_oauthlib >= 0.8.0, == 0.8.*" "requests_oauthlib>=0.8.0<2.0"
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
