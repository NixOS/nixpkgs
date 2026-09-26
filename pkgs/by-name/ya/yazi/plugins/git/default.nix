{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "0-unstable-2026-08-19";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "efa4d79da8ada35380ede5788d3f3b0ee9f70306";
    hash = "sha256-uRjuzA58DtxKW8kpTpe0pM54cAnyu5zQoPxJUeiSKL0=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
