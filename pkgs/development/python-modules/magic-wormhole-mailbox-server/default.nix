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
  pythonOlder,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole-mailbox-server";
  version = "0.4.1";
  pyproject = true;

  # python 3.12 support: https://github.com/magic-wormhole/magic-wormhole-mailbox-server/issues/41
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

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

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    attrs
    six
    twisted
    autobahn
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

  meta = {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server";
    changelog = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server/blob/${version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
  };
}
