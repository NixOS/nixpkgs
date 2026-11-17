{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline-created-time.yazi";
  version = "0-unstable-2025-09-04";

  src = fetchFromGitHub {
    owner = "wekauwau";
    repo = "yatline-created-time.yazi";
    rev = "7cd5e216554b0d6fcfd04bcde617726194a110ba";
    hash = "sha256-yhm/tzRHBL011Gp+bOqT+Ck/0BcR5smo49Gqfv0L3oI=";
  };

  meta = {
    description = "An addon to display the creation time of file or folder in your yatline.yazi";
    homepage = "https://github.com/wekauwau/yatline-created-time.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
  };
}
