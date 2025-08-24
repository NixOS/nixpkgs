{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libev,
  python,
}:

buildPythonPackage rec {
  pname = "bjoern";
  version = "3.2.2";
  format = "setuptools";

  # tests are not published to pypi anymore
  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = "bjoern";
    rev = version;
    hash = "sha256-drFLM6GsgrM8atQDxmb3/1bpj+C1WetQLjNbZqCTzog=";
    fetchSubmodules = true; # fetch http-parser and statsd-c-client submodules
  };

  buildInputs = [ libev ];

  checkPhase = ''
    ${python.interpreter} tests/keep-alive-behaviour.py 2>/dev/null
    ${python.interpreter} tests/test_wsgi_compliance.py
  '';

  meta = with lib; {
    homepage = "https://github.com/jonashaag/bjoern";
    description = "Screamingly fast Python 2/3 WSGI server written in C";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
