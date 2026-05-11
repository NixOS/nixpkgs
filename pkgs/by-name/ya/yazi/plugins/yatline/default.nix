{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "25.12.29-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "c5d4b487d6277dd68ea9d3c6537641bf4ae9cf8e";
    hash = "sha256-HjTRAfUHs6vlEWKruQWeA2wT/Mcd+WEHM90egFTYcWQ=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
