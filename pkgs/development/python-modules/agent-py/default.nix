{
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  lib,
  python,
  requests,
}:

buildPythonPackage rec {
  pname = "agent-py";
  version = "0.0.23";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nxW7WM/5gQbkFhx8lpLDm8KzZaMlRmjqE8tNtFBFqMM=";
  };

  propagatedBuildInputs = [
    requests
    aiohttp
  ];

  checkPhase = ''
    ${python.interpreter} tests/test_agent.py
  '';

  meta = with lib; {
    description = "Python wrapper around the Agent REST API";
    homepage = "https://github.com/ispysoftware/agent-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
