{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b9946d996226c9e47d5cd64a9452d7d4a3549ac7";
    hash = "sha256-auk/47dNcYjrIW7B92Odjvl/6nHP8QIC5tY3BlauQ3U=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
