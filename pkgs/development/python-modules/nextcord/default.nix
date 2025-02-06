{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  substituteAll,
  ffmpeg,
  libopus,
  aiohttp,
  aiodns,
  audioop-lts,
  brotli,
  faust-cchardet,
  orjson,
  pynacl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nextcord";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nextcord";
    repo = "nextcord";
    tag = "v${version}";
    hash = "sha256-zrxseQT98nNJHIA1It1JtOU8PFna/2zuIMIL7B1Ym+A=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      ffmpeg = "${ffmpeg}/bin/ffmpeg";
      libopus = "${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies =
    [
      aiodns
      aiohttp
      brotli
      faust-cchardet
      orjson
      pynacl
      setuptools # for pkg_resources, remove with next release
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
