{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  serpent,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyro5";
  version = "5.15";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Pyro5";
    inherit version;
    hash = "sha256-gsPfyYYLSfiXso/yT+ZxbIQWcsYAr4/kDQ46f6yaP14=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "Socket" ];

  pythonImportsCheck = [ "Pyro5" ];

  meta = with lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro5";
    changelog = "https://github.com/irmen/Pyro5/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
