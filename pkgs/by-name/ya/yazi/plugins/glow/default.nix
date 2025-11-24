{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "glow.yazi";
  version = "0-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "bd3eaa58c065eaf216a8d22d64c62d8e0e9277e9";
    hash = "sha256-mzW/ut/LTEriZiWF8YMRXG9hZ70OOC0irl5xObTNO40=";
  };

  meta = {
    description = "Glow preview plugin for yazi";
    homepage = "https://github.com/Reledia/glow.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
