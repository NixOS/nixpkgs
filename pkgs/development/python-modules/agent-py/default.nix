{ aiohttp, buildPythonPackage, fetchPypi, isPy3k, lib, python, requests }:

buildPythonPackage rec {
  pname = "agent-py";
  version = "0.0.23";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hx88m8b8kfb2gm6hii5ldjv7hlvqf99cz0w2vj0d0grrxcbn5cz";
  };

  propagatedBuildInputs = [ requests aiohttp ];

  checkPhase = ''
    ${python.interpreter} tests/test_agent.py
  '';

  meta = with lib; {
    description = "A python wrapper around the Agent REST API.";
    homepage = "https://github.com/ispysoftware/agent-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
