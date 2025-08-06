{
  lib,
  stdenv,
  aiohttp,
  audioop-lts,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg,
  libopus,
  pynacl,
  setuptools,
  withVoice ? true,
}:

let
  pname = "discord.py";
  version = "2.5.2";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = "discord.py";
    tag = "v${version}";
    hash = "sha256-xaZeOkfOhm1CL5ceu9g/Vlas4jpYoQDlGMEtACFY7PE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    audioop-lts
  ]
  ++ lib.optionals withVoice [ pynacl ];

  patchPhase = lib.optionalString withVoice ''
    substituteInPlace "discord/opus.py" \
      --replace-fail "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}'"

    substituteInPlace "discord/player.py" \
      --replace-fail "executable: str = 'ffmpeg'" "executable: str = '${lib.getExe ffmpeg}'"
  '';

  # Only have integration tests with discord
  doCheck = false;

  pythonImportsCheck = [
    "discord"
    "discord.types"
    "discord.ui"
    "discord.webhook"
    "discord.app_commands"
    "discord.ext.commands"
    "discord.ext.tasks"
  ];

  meta = {
    description = "Python wrapper for the Discord API";
    homepage = "https://discordpy.rtfd.org/";
    changelog = "https://github.com/Rapptz/discord.py/blob/v${version}/docs/whats_new.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
