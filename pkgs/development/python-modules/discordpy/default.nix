{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, libopus
, pynacl
, pythonOlder
, withVoice ? true
, ffmpeg
}:

buildPythonPackage rec {
  pname = "discord.py";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DX9AmVhwP7XgzUApY8d+UB6LGqymErsaSzaisuKAOB0=";
  };

  propagatedBuildInputs = [
    aiohttp
  ] ++ lib.optionals withVoice [
    libopus
    pynacl
    ffmpeg
  ];

  patchPhase = ''
    substituteInPlace "discord/opus.py" \
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
  '' + lib.optionalString withVoice ''
    substituteInPlace "discord/player.py" \
      --replace "executable='ffmpeg'" "executable='${ffmpeg}/bin/ffmpeg'"
  '';

  # Only have integration tests with discord
  doCheck = false;

  pythonImportsCheck = [
    "discord"
    "discord.file"
    "discord.member"
    "discord.user"
    "discord.state"
    "discord.guild"
    "discord.webhook"
    "discord.ext.commands.bot"
  ];

  meta = with lib; {
    description = "Python wrapper for the Discord API";
    homepage = "https://discordpy.rtfd.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar ];
  };
}
