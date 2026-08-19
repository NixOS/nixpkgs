{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "allmytoes.yazi";
  version = "0-unstable-2025-11-22";

  src = fetchFromGitHub {
    owner = "Sonico98";
    repo = "allmytoes.yazi";
    rev = "acdc53be76434a82218eed8e1fda5512971bf3cc";
    hash = "sha256-zZ9L0FrcxFvSuDJwi6VHQXDT7b/sM4DhZ3LPi/i9tig=";
  };

  meta = {
    description = "Generate freedesktop-compatible thumbnails while using yazi";
    homepage = "https://github.com/Sonico98/allmytoes.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luminarleaf ];
  };
}
