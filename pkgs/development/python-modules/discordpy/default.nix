{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, withVoice ? true, libopus
, aiohttp
, websockets
}:

buildPythonPackage rec {
  pname = "discord.py";
  version = "1.5.1";
  disabled = pythonOlder "3.5.3";

  # only distributes wheels on pypi now
  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bidyclwv20p1kfphj21r5gm3kr2vxx0zd151wg7fcngbbx7gmza";
  };

  propagatedBuildInputs = [ aiohttp websockets ];
  patchPhase = ''
    substituteInPlace "requirements.txt" \
      --replace "aiohttp>=3.6.0,<3.7.0" "aiohttp" \
      --replace "websockets>=6.0,!=7.0,!=8.0,!=8.0.1,<9.0" "websockets"
  '' + lib.optionalString withVoice ''
    substituteInPlace "discord/opus.py" \
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
  '';

  # only have integration tests with discord
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
    description = "A python wrapper for the Discord API";
    homepage = "https://discordpy.rtfd.org/";
    maintainers = [ maintainers.ivar ];
    license = licenses.mit;
  };
}
