{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pdm-backend,
  pydantic,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "agent-client-protocol";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "python-sdk";
    rev = version;
    hash = "sha256-WgqAm8u/mmMEuObhOp1t1HDL2e00ra9YKXjtDj0NIL8=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    pydantic
    python-dateutil
  ];

  meta = with lib; {
    description = "Python SDK for Agent Client Protocol (ACP)";
    homepage = "https://github.com/agentclientprotocol/python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
