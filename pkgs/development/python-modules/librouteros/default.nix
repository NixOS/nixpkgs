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
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    tag = version;
    hash = "sha256-Xn/mXNfgC41MR12PpYgDwMfHyn9iyKt4tSbEWI340Dc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.18,<0.12.0" "uv_build"
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

  disabledTestPaths = [
    # Disable tests which require QEMU to run
    "tests/integration/test_config.py"
    "tests/integration/test_general.py"
    "tests/integration/test_generator.py"
    "tests/integration/test_path.py"
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
