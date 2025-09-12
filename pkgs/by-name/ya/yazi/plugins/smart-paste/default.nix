{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-paste.yazi";
  version = "25.5.31-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "86d28e4fb4f25f36cc501b8cb0badb37a6b14263";
    hash = "sha256-m/gJTDm0cVkIdcQ1ZJliPqBhNKoCW1FciLkuq7D1mxo=";
  };

  meta = {
    description = "Paste files into the hovered directory or to the CWD if hovering over a file";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
