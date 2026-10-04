{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  click,
  cryptography,
  dateparser,
  fetchFromGitHub,
  marshmallow-dataclass,
  pyjwt,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  syrupy_6,
  tabulate,
  typeguard,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "renault-api";
  version = "0.5.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bnql9nnRlVZa2d5FdejfLJp2rNi0wNXUdNOmMuLnQ+0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.21,<0.13" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    cryptography
    marshmallow-dataclass
    pyjwt
  ];

  optional-dependencies = {
    cli = [
      click
      dateparser
      tabulate
    ];
  };

  nativeCheckInputs = [
    aiointercept
    pytest-asyncio
    pytestCheckHook
    syrupy_6
    typeguard
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "renault_api" ];

  meta = {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    changelog = "https://github.com/hacf-fr/renault-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "renault-api";
  };
})
