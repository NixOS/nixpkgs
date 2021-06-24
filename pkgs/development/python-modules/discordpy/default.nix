{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, libopus
, pynacl
, pythonOlder
, websockets
, withVoice ? true
}:

buildPythonPackage rec {
  pname = "discord.py";
  version = "1.7.1";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dpASIqe6rJEyiWJyPbQhq9M54lX1ilfp4UuGnbJcFLo=";
  };

  propagatedBuildInputs = [
    aiohttp
    websockets
  ] ++ lib.optionalString withVoice [
    libopus
    pynacl
  ];

  patchPhase = ''
    substituteInPlace "discord/opus.py" \
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
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
    maintainers = [ maintainers.ivar ];
    license = licenses.mit;
  };
}
