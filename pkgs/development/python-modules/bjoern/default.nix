{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libev,
  python,
}:

buildPythonPackage rec {
  pname = "bjoern";
  version = "3.2.1";
  format = "setuptools";

  # tests are not published to pypi anymore
  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    hash = "sha256-d7u/lEh2Zr5NYWYu4Zr7kgyeOIQuHQLYrZeiZMHbpio=";
    fetchSubmodules = true; # fetch http-parser and statsd-c-client submodules
  };

  buildInputs = [ libev ];

  checkPhase = ''
    ${python.interpreter} tests/keep-alive-behaviour.py 2>/dev/null
    ${python.interpreter} tests/test_wsgi_compliance.py
  '';

  meta = with lib; {
    homepage = "https://github.com/jonashaag/bjoern";
    description = "A screamingly fast Python 2/3 WSGI server written in C";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
