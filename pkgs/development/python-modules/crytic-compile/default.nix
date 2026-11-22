{
  lib,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  pycryptodome,
  uv-build,
  solc-select,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "crytic-compile";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    tag = finalAttrs.version;
    hash = "sha256-0zpalWsyFzsgSrmTi9WyHfRcRympv2WoJNEtzpWXmGk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.6,<0.10" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    cbor2
    pycryptodome
    solc-select
    toml
  ];

  # Test require network access
  doCheck = false;

  # required for import check to work
  # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  env.HOME = "/tmp";

  pythonImportsCheck = [ "crytic_compile" ];

  meta = {
    description = "Abstraction layer for smart contract build systems";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      arturcygan
      hellwolf
    ];
    mainProgram = "crytic-compile";
  };
})
