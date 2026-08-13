{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yamb.yazi";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "h-hg";
    repo = "yamb.yazi";
    rev = "971b85862a1a2c5b8133da88b0dd4569adff296e";
    hash = "sha256-pbwKj4NuIiBMyuRVtbOYWBREZbyg1mKLoCWIAkxrygc=";
  };

  meta = {
    description = "Yet another bookmarks plugins. It supports persistence, jumping by a key, jumping by fzf.";
    homepage = "https://github.com/h-hg/yamb.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tornax ];
  };
}
