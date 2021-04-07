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
  version = "1.7.0";
  disabled = pythonOlder "3.5.3";

  # only distributes wheels on pypi now
  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i5k2qb894rjksn21pk9shash1y7v4138rkk8mqr1a1yvgnr5ibg";
  };

  propagatedBuildInputs = [ aiohttp websockets ];
  patchPhase = ''
    substituteInPlace "requirements.txt" \
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
