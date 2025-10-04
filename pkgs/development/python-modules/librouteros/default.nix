{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  toml,
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "3.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    tag = version;
    hash = "sha256-vN12LYqFOU7flD6bTFtGw5VhPJ238pZ0MStM3ljwDU4=";
  };

  build-system = [ poetry-core ];

  dependencies = [ toml ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests which require QEMU to run
    "test_login"
    "test_long_word"
    "test_query"
    "test_add_then_remove"
    "test_add_then_update"
    "test_generator_ditch"
  ];

  pythonImportsCheck = [ "librouteros" ];

  meta = with lib; {
    description = "Python implementation of the MikroTik RouterOS API";
    homepage = "https://librouteros.readthedocs.io/";
    changelog = "https://github.com/luqasz/librouteros/blob/${version}/CHANGELOG.rst";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
