{
  lib,
  base58,
  buildPythonPackage,
  fetchFromGitHub,
  idna,
  netaddr,
  py-cid,
  py-multicodec,
  trio,
  pytestCheckHook,
  setuptools,
  psutil,
  varint,
  dnspython,
  trio-typing,
}:

buildPythonPackage rec {
  pname = "py-multiaddr";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = "py-multiaddr";
    tag = "v${version}";
    hash = "sha256-mlHcuLVtczp3APXJFkWbjeY7xU39eFERa8hhiOEwBSU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    varint
    base58
    netaddr
    dnspython
    trio-typing
    trio
    idna
    py-cid
    psutil
    py-multicodec
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multiaddr" ];

  disabledTests = [
    # Test is outdated
    "test_resolve_cancellation_with_error"
    # AssertionError
    "test_ipv4_wildcard"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_resolvers.py"
  ];

  meta = with lib; {
    description = "Composable and future-proof network addresses";
    homepage = "https://github.com/multiformats/py-multiaddr";
    changelog = "https://github.com/multiformats/py-multiaddr/releases/tag/${src.tag}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ Luflosi ];
  };
}
