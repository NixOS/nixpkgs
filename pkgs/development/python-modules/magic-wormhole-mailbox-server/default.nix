{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  twisted,
  autobahn,
  treq,
  nixosTests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole-mailbox-server";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oAegNnIpMgRldoHb9QIEXW1YF8V/mq4vIibm6hoAjKE=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      attrs
      autobahn
      setuptools # pkg_resources is referenced at runtime
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
    changelog = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server/blob/${version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
  };
}
