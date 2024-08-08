{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,

  aiohttp,

  withVoice ? true,
  pynacl,
  libopus,
  ffmpeg,
}:

buildPythonPackage rec {
  pname = "disnake";
  version = "2.9.2";

  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "DisnakeDev";
    repo = "disnake";
    rev = "refs/tags/v${version}";
    hash = "sha256-J7nNVHhkQ9ekGjioObxaTL0OhjLjHHYlgbPdAG9Vz4o=";
  };

  dependencies =
    [ aiohttp ]
    ++ lib.optionals withVoice [
      pynacl
      libopus
      ffmpeg
    ];

  postPatch = lib.optionalString withVoice ''
    substituteInPlace "disnake/opus.py" \
      --replace-fail "ctypes.util.find_library('opus')" "'${libopus}/lib/libopus.so.0'"
    substituteInPlace "disnake/player.py" \
      --replace-fail "executable='ffmpeg'" "executable='${ffmpeg}/bin/ffmpeg'"
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
