{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  stamina,
  toml,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "librouteros";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    tag = finalAttrs.version;
    hash = "sha256-5b/f8B0npEF81nfYGpQ6vT9Px45m0ACQry6CJUXjIiI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.18,<0.9.0" "uv_build"
  '';

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
    changelog = "https://github.com/luqasz/librouteros/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
