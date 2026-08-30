{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mime-ext.yazi";
  version = "0-unstable-2026-08-07";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "0be29a913ad61c6d119abfaaf253e96e6af5db67";
    hash = "sha256-IDmmXzQKFx3QZ9u5lMwcTOeWeMPWzIBeKBXkGAgJMaI=";
  };

  meta = {
    description = "Mime-type provider based on a file extension database, replacing the builtin file to speed up mime-type retrieval at the expense of accuracy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
