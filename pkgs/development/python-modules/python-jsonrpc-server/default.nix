{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  ujson,
  versioneer,
}:

buildPythonPackage rec {
  pname = "python-jsonrpc-server";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-jsonrpc-server";
    rev = "refs/tags/${version}";
    hash = "sha256-hlMw+eL1g+oe5EG7mwK8jSX0UcOQo7La+BZ3tjEojl0=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [ ujson ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyls_jsonrpc" ];

  meta = with lib; {
    description = "Module for erver implementation of the JSON RPC 2.0 protocol";
    homepage = "https://github.com/palantir/python-jsonrpc-server";
    changelog = "https://github.com/palantir/python-jsonrpc-server/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
