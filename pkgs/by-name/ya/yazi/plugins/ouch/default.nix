{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "ouch.yazi";
  version = "0-unstable-2025-06-10";

  src = fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "1ee69a56da3c4b90ec8716dd9dd6b82e7a944614";
    hash = "sha256-4KZeDkMXlhUV0Zh+VGBtz9kFPGOWCexYVuKUSCN463o=";
  };

  meta = {
    description = "Yazi plugin to preview archives";
    homepage = "https://github.com/ndtoan96/ouch.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
