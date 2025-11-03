{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rich-preview.yazi";
  version = "0-unstable-2025-10-22";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "831234e828d292913f4b174a1ca2be2fb1080f22";
    hash = "sha256-CK3ynjs53I1tRqARoOYMgBczBrcle+pwpUhHt3VpSXs=";
  };

  meta = {
    description = "Preview file types using rich in Yazi";
    homepage = "https://github.com/AnirudhG07/rich-preview.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
