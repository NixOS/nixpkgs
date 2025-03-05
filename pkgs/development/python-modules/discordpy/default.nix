{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  libopus,
  pynacl,
  withVoice ? true,
  ffmpeg,
  setuptools,
}:

let
  pname = "discord.py";
  version = "2.4.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = "discord.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-GIwXx7bRCH2+G3zlilJ/Tb8el50SDbxGGX2/1bqL3+U=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ] ++ lib.optionals withVoice [ pynacl ];

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
