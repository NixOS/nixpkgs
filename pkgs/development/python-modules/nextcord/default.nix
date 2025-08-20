{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  replaceVars,
  ffmpeg,
  libopus,
  aiohttp,
  aiodns,
  audioop-lts,
  brotli,
  orjson,
  poetry-core,
  poetry-dynamic-versioning,
  pynacl,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "nextcord";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "nextcord";
    repo = "nextcord";
    tag = "v${version}";
    hash = "sha256-ex6amnB51Jla5ia2HVaMOZsDOEtgJ8RB1eNTLpXNzSY=";
  };

  patches = [
    (replaceVars ./paths.patch {
      ffmpeg = "${ffmpeg}/bin/ffmpeg";
      libopus = "${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = ''
    # disable dynamic versioning
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"' \
      --replace-fail 'enable = true' 'enable = false'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiodns
    aiohttp
    brotli
    orjson
    pynacl
    typing-extensions
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    audioop-lts
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nextcord"
    "nextcord.ext.commands"
    "nextcord.ext.tasks"
  ];

  meta = with lib; {
    changelog = "https://github.com/nextcord/nextcord/blob/${src.tag}/docs/whats_new.rst";
    description = "Python wrapper for the Discord API forked from discord.py";
    homepage = "https://github.com/nextcord/nextcord";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
