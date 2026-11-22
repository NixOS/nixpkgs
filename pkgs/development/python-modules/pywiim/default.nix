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
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjcumming";
    repo = "pywiim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3KnRiTDXWxIpVg+FQZOlH61pgmgkMe83GKTvtVuEFh8=";
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
