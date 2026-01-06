{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline-catppuccin.yazi";
  version = "0-unstable-2025-03-05";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline-catppuccin.yazi";
    rev = "8cc4773ecab8ee8995485d53897e1c46991a7fea";
    hash = "sha256-Wz53zjwFyflnxCIMjAv+nzcgDriJwVYBX81pFXJUzc4=";
  };

  meta = {
    description = "Soothing pastel theme for Yatline";
    homepage = "https://github.com/imsi32/yatline-catppuccin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
