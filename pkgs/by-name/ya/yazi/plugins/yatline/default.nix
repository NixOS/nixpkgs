{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    tag = "v0.5.0";
    hash = "sha256-HjTRAfUHs6vlEWKruQWeA2wT/Mcd+WEHM90egFTYcWQ=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
