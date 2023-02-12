{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, ffmpeg
, libopus
, aiohttp
, aiodns
, brotli
, cchardet
, orjson
, pynacl
}:

buildPythonPackage rec {
  pname = "nextcord";
  version = "2.3.3";

  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nextcord";
    repo = "nextcord";
    rev = "refs/tags/v${version}";
    hash = "sha256-0ZWPoDLlGwLWReOeZc2GgW1FbUufrxTzUndNe5h7Kas=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      ffmpeg = "${ffmpeg}/bin/ffmpeg";
      libopus = "${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  propagatedBuildInputs = [
    aiodns
    aiohttp
    brotli
    cchardet
    orjson
    pynacl
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nextcord"
    "nextcord.ext.commands"
    "nextcord.ext.tasks"
  ];

  meta = with lib; {
    changelog = "https://github.com/nextcord/nextcord/blob/${src.rev}/docs/whats_new.rst";
    description = "Python wrapper for the Discord API forked from discord.py";
    homepage = "https://github.com/nextcord/nextcord";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
