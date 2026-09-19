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
  pytest,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-xdist,
  pyyaml,

  # optional deps
  mcp,
}:
buildPythonPackage (finalAttrs: {
  pname = "pywiim";
  version = "2.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjcumming";
    repo = "pywiim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ORAC/94C8Q/ASr8qZmRQg2tlc46G4nLJg9+EHgJwGQ0=";
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
    pytest
    pytest-asyncio
    pytest-cov-stub
    pytest-xdist
    pyyaml
  ]
  ++ finalAttrs.passthru.optional-dependencies.mcp;

  pythonImportsCheck = [ "pywiim" ];

  meta = with lib; {
    changelog = "https://github.com/mjcumming/pywiim/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Python library for WiiM/LinkPlay device communication";
    homepage = "https://github.com/mjcumming/pywiim";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ tebriel ];
    mainProgram = "wiim-discover";
  };
})
