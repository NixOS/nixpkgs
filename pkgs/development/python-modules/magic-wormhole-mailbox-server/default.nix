{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  attrs,
  twisted,
  autobahn,
  treq,
  nixosTests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "magic-wormhole-mailbox-server";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole-mailbox-server";
    tag = finalAttrs.version;
    hash = "sha256-Ckwkvw4pMEGUTarfzg1GOodHMwM5hVix2bPCZTI6hxU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    autobahn
    twisted
  ]
  ++ autobahn.optional-dependencies.twisted
  ++ twisted.optional-dependencies.tls;

  pythonImportsCheck = [ "wormhole_mailbox_server" ];

  nativeCheckInputs = [
    pytestCheckHook
    treq
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # these tests fail in Darwin's sandbox
    "src/wormhole_mailbox_server/test/test_web.py"
  ];

  passthru.tests = {
    inherit (nixosTests) magic-wormhole-mailbox-server;
  };

  meta = {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server";
    changelog = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server/blob/${finalAttrs.src.rev}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
  };
})
