{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "25.5.31-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "3d1efb706924112daed986a4eef634e408bad65e";
    hash = "sha256-GgEg1A5sxaH7hR1CUOO9WV21kH8B2YUGAtOapcWLP7Y=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
