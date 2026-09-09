{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "full-border.yazi";
  version = "0-unstable-2026-08-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "e1031c618c6b8333df9b50dbfff515c483920d25";
    hash = "sha256-Uk4KhZdQFOwuOsjH7Z81POBfkvgkYoYx2F8HcXe3l7I=";
  };

  meta = {
    description = "Add a full border to Yazi to make it look fancier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
