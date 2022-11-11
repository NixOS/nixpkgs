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
  version = "2.2.0";

  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nextcord";
    repo = "nextcord";
    rev = "refs/tags/v${version}";
    hash = "sha256-2VlmcldbW+BfQRzOjCsh6r29qzwD+SG8H8arbTDg94k=";
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
    description = "Python wrapper for the Discord API forked from discord.py";
    homepage = "https://github.com/nextcord/nextcord";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
