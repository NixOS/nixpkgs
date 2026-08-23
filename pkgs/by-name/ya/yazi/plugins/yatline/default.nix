{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin (finalAttrs: {
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
    changelog = "https://github.com/imsi32/yatline.yazi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
})
