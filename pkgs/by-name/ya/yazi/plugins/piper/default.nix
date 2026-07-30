{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "0-unstable-2026-07-05";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "8cd50c622898d3ace3ca821f540241965308289a";
    hash = "sha256-f4y952sUF/lrHMX6enQts/obk2DeatqAcaVHfjTD65k=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
