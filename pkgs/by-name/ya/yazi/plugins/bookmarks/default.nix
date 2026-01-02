{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bookmarks.yazi";
  version = "0.2.5-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "bookmarks.yazi";
    rev = "9ef1254d8afe88aba21cd56a186f4485dd532ab8";
    hash = "sha256-GQFBRB2aQqmmuKZ0BpcCAC4r0JFKqIANZNhUC98SlwY=";
  };

  meta = {
    description = "Yazi plugin that adds the basic functionality of vi-like marks";
    homepage = "https://github.com/dedukun/bookmarks.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
