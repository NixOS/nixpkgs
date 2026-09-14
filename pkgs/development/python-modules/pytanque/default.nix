{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  requests,
  typing-extensions,

  # tests
  rocqPackages,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytanque";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "pytanque";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Hae21BuMdE6MjRdiBO7fcsuS4HzahOdLLhynAUox3I=";
  };

  # The tests hardcode 127.0.0.1:8765 and reuse any pet-server already
  # listening there. macOS has no network namespaces, so the python3.13 and
  # python3.14 builds drive each other's server. Drop once released upstream:
  # https://github.com/LLM4Rocq/pytanque/pull/19
  patches = [
    (fetchpatch2 {
      name = "tests-per-session-port.patch";
      url = "https://github.com/remix7531/pytanque/commit/e772dbfa4d23cb4f14b0e9270c1685b289f20683.patch?full_index=1";
      hash = "sha256-6zZsDWoZmn5oM3usCX/jwqAFJYWTeu3UTZM2Edg6ZtM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    # coq-lsp provides the pet and pet-server binaries the tests drive.
    rocqPackages.coq-lsp
    rocqPackages.coq
    pytestCheckHook
  ];

  # Every test loads examples/foo.v, which needs the stdlib that Rocq 9.0 split
  # out. Without it pet serves a failed document and the assertions stay green.
  # The setup hook fires over buildInputs, so stdlib has to be a checkInput.
  checkInputs = [ rocqPackages.stdlib ];

  # The suite spawns pet-server on the loopback and drives it over TCP.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pytanque" ];

  meta = {
    description = "Python client for the Petanque JSON-RPC interface to coq-lsp";
    homepage = "https://github.com/LLM4Rocq/pytanque";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
