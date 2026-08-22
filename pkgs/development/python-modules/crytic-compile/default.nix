{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
  cbor2,
  pycryptodome,
  solc-select,
  solc,
}:

buildPythonPackage (finalAttrs: {
  pname = "crytic-compile";
  version = "0.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    tag = finalAttrs.version;
    hash = "sha256-7FEjye7ukvNeF2LKUo4X/lAprXR87rc6WWtjBJnVL+0=";
  };

  dependencies = [
    cbor2
    pycryptodome
    solc-select
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.6,<0.10" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  nativeBuildInputs = [
    pytestCheckHook
    solc
  ];

  # Tests require network access
  disabledTestPaths = [
    "tests/test_sourcify_proxy.py"
  ];

  # required for import check to work
  # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  env.HOME = "/tmp";
  pythonImportsCheck = [ "crytic_compile" ];

  meta = {
    description = "Abstraction layer for smart contract build systems";
    mainProgram = "crytic-compile";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      arturcygan
      hellwolf
    ];
  };
})
