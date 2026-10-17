{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rich-preview.yazi";
  version = "0-unstable-2026-08-07";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "02597c4a129a36e3ab013b1fd052cf0f555d5490";
    hash = "sha256-8QfBzKyNmKFxwtOmhhpnxUZBRmrN3mPWV/n/0MZlsYo=";
  };

  meta = {
    description = "Preview file types using rich in Yazi";
    homepage = "https://github.com/AnirudhG07/rich-preview.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
