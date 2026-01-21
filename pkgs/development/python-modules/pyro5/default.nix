{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  serpent,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyro5";
  version = "5.16";
  format = "setuptools";

  src = fetchPypi {
    pname = "Pyro5";
    inherit version;
    hash = "sha256-1AQY7SrO4NkJPa9QI+0LDLSFprYjQpNK256AGVb1c4s=";
  };

  propagatedBuildInputs = [ serpent ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Ignore network related tests, which fail in sandbox
    "StartNSfunc"
    "Broadcast"
    "GetIP"
    "TestNameServer"
    "TestBCSetup"
    # time sensitive tests
    "testTimeoutCall"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "Socket" ];

  pythonImportsCheck = [ "Pyro5" ];

  meta = {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro5";
    changelog = "https://github.com/irmen/Pyro5/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
