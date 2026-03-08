{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline-catppuccin.yazi";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline-catppuccin.yazi";
    rev = "6c3f166231d054bd500585b83280258f3941e3af";
    hash = "sha256-NRmXzgRMnjCKbg8V+TuppBRLbP1NAz7taRtYv8C7kqY=";
  };

  meta = {
    description = "Soothing pastel theme for Yatline";
    homepage = "https://github.com/imsi32/yatline-catppuccin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
