{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin (finalAttrs: {
  pname = "yatline.yazi";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    tag = "v0.5.1";
    hash = "sha256-U7MAZSc0iPiRvLZM8tKbNd749pblarB1Y48lH13uLuU=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    changelog = "https://github.com/imsi32/yatline.yazi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
})
