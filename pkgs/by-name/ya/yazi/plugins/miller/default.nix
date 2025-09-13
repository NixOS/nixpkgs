{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "miller.yazi";
  version = "0-unstable-2025-04-17";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "miller.yazi";
    rev = "0a3d1316e38132ae9a6b91fbd69bab295cbbf2fe";
    hash = "sha256-pZpx7V5ud5JhEkgkfVBSuM0CFIIUXZZ+pOX0xVlHf+0=";
  };

  meta = {
    description = "Miller, now in yazi";
    homepage = "https://github.com/Reledia/miller.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
