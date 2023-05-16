{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "2.3.2";
=======
  version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Rapptz";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-bZoYdDpk34x+Vw1pAZ3EcTFp2JJ/Ow0Jfof/XjqeRmY=";
=======
    hash = "sha256-Rh3gijm67LVyOaliP7w3YwKviKydnxXvu4snNrM5H1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}'"
=======
      --replace "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/Rapptz/discord.py/blob/v${version}/docs/whats_new.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar ];
  };
}
