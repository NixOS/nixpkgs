{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  stamina,
  uv-build,
  toml,
}:

buildPythonPackage rec {
  pname = "librouteros";
  version = "4.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luqasz";
    repo = "librouteros";
    tag = version;
    hash = "sha256-PbRnHsZSSbr7dkVb3F+1CB5TH30wgoGGXEcRBVjuN5Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build==0.12.*" uv_build
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

  # Disable tests which require QEMU to run
  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "librouteros" ];

  meta = {
    description = "Python implementation of the MikroTik RouterOS API";
    homepage = "https://librouteros.readthedocs.io/";
    changelog = "https://github.com/luqasz/librouteros/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
