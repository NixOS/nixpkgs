{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rich-preview.yazi";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "843c3faf0a99f5ce31d02372c868d8dae92ca29d";
    hash = "sha256-celObHo9Y3pFCd1mTx1Lz77Tc22SJTleRblAkbH/RqY=";
  };

  meta = {
    description = "Preview file types using rich in Yazi";
    homepage = "https://github.com/AnirudhG07/rich-preview.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
