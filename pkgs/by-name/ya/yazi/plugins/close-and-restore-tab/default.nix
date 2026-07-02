{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "close-and-restore-tab.yazi";
  version = "0-unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "close-and-restore-tab.yazi";
    rev = "b2153bc68696edc8e17fc90e73310e274035c674";
    hash = "sha256-3bcnXXYfmvJGxxVKEHAy3so1KRFr1oIdj01A8WIU5VM=";
  };

  meta = {
    description = "A Yazi plugin that adds the functionality to close and restore tab";
    homepage = "https://github.com/MasouShizuka/close-and-restore-tab.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
  };
}
