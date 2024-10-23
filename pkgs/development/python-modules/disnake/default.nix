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
  pname = "disnake";
  version = "2.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "DisnakeDev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J7nNVHhkQ9ekGjioObxaTL0OhjLjHHYlgbPdAG9Vz4o=";
  };

  propagatedBuildInputs = [
    aiohttp
  ] ++ lib.optionals withVoice [
    libopus
    pynacl
    ffmpeg
  ];

  patchPhase = ''
    substituteInPlace "disnake/opus.py" \
      --replace "ctypes.util.find_library("opus")" "'${libopus}/lib/libopus.so.0'"
  '' + lib.optionalString withVoice ''
    substituteInPlace "disnake/player.py" \
      --replace "executable='ffmpeg'" "executable='${ffmpeg}/bin/ffmpeg'"
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

  meta = with lib; {
    description = "An API wrapper for Discord written in Python";
    homepage = "https://disnake.dev/";
    changelog = "https://github.com/DisnakeDev/disnake/blob/v${version}/docs/whats_new.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ infinidoge ];
  };
}
