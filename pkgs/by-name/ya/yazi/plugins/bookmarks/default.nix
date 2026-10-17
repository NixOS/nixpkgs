{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bookmarks.yazi";
  version = "0-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "sidhantunnithan";
    repo = "bookmarks.yazi";
    rev = "a61e524a2b74f8f09e5af2265df0a32605f7528c";
    hash = "sha256-u5AtP6Mp6OwLQps10PNV1xjwjwfDmZxND0NDnIuqZRY=";
  };

  meta = {
    description = "Yazi plugin that adds the basic functionality of vi-like marks";
    homepage = "https://github.com/dedukun/bookmarks.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
