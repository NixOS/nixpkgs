{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  six,
  attrs,
  twisted,
  autobahn,
  treq,
  mock,
  nixosTests,
  pythonOlder,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole-mailbox-server";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GvEFkpCcqvUZwA5wbqyELF53+NQ1YhX+nGHHsiWKiPs=";
  };

  patches = [
    (fetchpatch {
      # Remove the 'U' open mode removed, https://github.com/magic-wormhole/magic-wormhole-mailbox-server/pull/34
      name = "fix-for-python-3.11.patch";
      url = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server/commit/4b358859ba80de37c3dc0a5f67ec36909fd48234.patch";
      hash = "sha256-RzZ5kD+xhmFYusVzAbGE+CODXtJVR1zN2rZ+VGApXiQ=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    attrs
    autobahn
    setuptools # pkg_resources is referenced at runtime
    six
    twisted
  ] ++ autobahn.optional-dependencies.twisted ++ twisted.optional-dependencies.tls;

  pythonImportsCheck = [ "wormhole_mailbox_server" ];

  nativeCheckInputs = [
    pytestCheckHook
    treq
    mock
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
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
    # Python 3.12 support: https://github.com/magic-wormhole/magic-wormhole-mailbox-server/issues/41
    broken = pythonOlder "3.7" || pythonAtLeast "3.12";
  };
}
