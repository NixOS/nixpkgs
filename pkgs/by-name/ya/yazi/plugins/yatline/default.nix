{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "0-unstable-2025-03-05";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "6b0fc1ef5eca034460b4c69cb87c424103227a2e";
    hash = "sha256-JiUik4umi+ujsJmHliUbLsIj7ZTKayrWAAM8HmRdjwk=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line.";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
