{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rich-preview.yazi";
  version = "0-unstable-2025-04-22";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "fdcf37320e35f7c12e8087900eebffcdafaee8cb";
    hash = "sha256-HO9hTCfgGTDERClZaLnUEWDvsV9GMK1kwFpWNM1wq8I=";
  };

  meta = {
    description = "Preview file types using rich in Yazi";
    homepage = "https://github.com/AnirudhG07/rich-preview.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
