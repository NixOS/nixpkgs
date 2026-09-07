{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  uv-build,
  stamina,
  toml,
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    tag = version;
    hash = "sha256-iqpaHSA+1AuN+VBfDfpxSjl5/g24yjbPmZd+dG32izQ=";
  };

  build-system = [ uv-build ];

  dependencies = [ toml ];

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    stamina
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

  meta = {
    description = "Python implementation of the MikroTik RouterOS API";
    homepage = "https://librouteros.readthedocs.io/";
    changelog = "https://github.com/luqasz/librouteros/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
