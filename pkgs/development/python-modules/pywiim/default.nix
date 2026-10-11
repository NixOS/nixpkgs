{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,

  # deps
  aiohttp,
  pydantic,
  async-upnp-client,
  m3u8,
  mutagen,

  # dev dependencies
  pytest-asyncio,
  pytest-cov-stub,
  pytest-xdist,
  pyyaml,

  # optional deps
  mcp,
}:
buildPythonPackage (finalAttrs: {
  pname = "pywiim";
  version = "2.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjcumming";
    repo = "pywiim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q7kVJjt7e1PCTdlzjhp+c6lUujEQCaOnzK18G3pOWr8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    async-upnp-client
    m3u8
    mutagen
    pydantic
  ];

  optional-dependencies = {
    mcp = [
      mcp
    ]
    ++ mcp.optional-dependencies.cli;
  };

  nativeCheckInputs = [
    pytestCheckHook

    # dev dependencies
    pytest-asyncio
    pytest-cov-stub
    pytest-xdist
    pyyaml
  ]
  ++ finalAttrs.passthru.optional-dependencies.mcp;

  pythonImportsCheck = [ "pywiim" ];

  meta = {
    changelog = "https://github.com/mjcumming/pywiim/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python library for WiiM/LinkPlay device communication";
    homepage = "https://github.com/mjcumming/pywiim";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tebriel ];
    mainProgram = "wiim-discover";
  };
})
