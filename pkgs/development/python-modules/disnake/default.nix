{
  lib,
  setuptools,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  libopus,
  pynacl,
  pythonOlder,
  withVoice ? true,
  ffmpeg,
}:

buildPythonPackage rec {
  pname = "disnake";
  version = "2.10.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "DisnakeDev";
    repo = "disnake";
    tag = "v${version}";
    hash = "sha256-MQxYkUA3uclmY2cKBr4DsBg79ovsH1EsMOjiVPGaLVE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ]
  ++ lib.optionals withVoice [
    libopus
    pynacl
    ffmpeg
  ];

  postPatch = lib.optionalString withVoice ''
    substituteInPlace "disnake/opus.py" \
      --replace-fail 'ctypes.util.find_library("opus")' "'${libopus}/lib/libopus.so.0'"
    substituteInPlace "disnake/player.py" \
      --replace-fail 'executable: str = "ffmpeg"' 'executable: str="${ffmpeg}/bin/ffmpeg"'
  '';

  # Only have integration tests with discord
  doCheck = false;

  pythonImportsCheck = [
    "disnake"
    "disnake.file"
    "disnake.member"
    "disnake.user"
    "disnake.state"
    "disnake.guild"
    "disnake.webhook"
    "disnake.ext.commands.bot"
  ];

  meta = {
    description = "API wrapper for Discord written in Python";
    homepage = "https://disnake.dev/";
    changelog = "https://github.com/DisnakeDev/disnake/blob/v${version}/docs/whats_new.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
