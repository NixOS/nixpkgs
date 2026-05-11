{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rich-preview.yazi";
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "7d616ad88498747b46124f32a35847324862cd83";
    hash = "sha256-KHmjff7tHFLkPqOs8IdWQ0mCliSZn/mIKYof+ulnddk=";
  };

  meta = {
    description = "Preview file types using rich in Yazi";
    homepage = "https://github.com/AnirudhG07/rich-preview.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
