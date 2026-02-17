{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  serpent,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyro5";
  version = "5.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "Pyro5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8ORwfzPpcNQdGRNe1EnY0A/+9itmSY3ouvreOcc18u8=";
  };

  build-system = [ setuptools ];

  dependencies = [ serpent ];

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
    changelog = "https://github.com/irmen/Pyro5/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})
