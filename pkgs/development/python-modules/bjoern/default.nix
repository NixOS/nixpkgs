{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libev,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bjoern";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = "bjoern";
    tag = version;
    hash = "sha256-drFLM6GsgrM8atQDxmb3/1bpj+C1WetQLjNbZqCTzog=";
    fetchSubmodules = true; # fetch http-parser and statsd-c-client submodules
  };

  build-system = [ setuptools ];

  buildInputs = [ libev ];

  checkPhase = ''
    ${python.interpreter} tests/keep-alive-behaviour.py 2>/dev/null
    ${python.interpreter} tests/test_wsgi_compliance.py
  '';

  meta = with lib; {
    homepage = "https://github.com/jonashaag/bjoern";
    description = "Screamingly fast Python 2/3 WSGI server written in C";
    changelog = "https://github.com/jonashaag/bjoern/blob/${src.tag}/CHANGELOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
