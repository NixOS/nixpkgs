{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rsync.yazi";
  version = "0-unstable-2025-09-20";
  src = fetchFromGitHub {
    owner = "GianniBYoung";
    repo = "rsync.yazi";
    rev = "824d8a35bf1f13742d19ecd93521bedc547fa809";
    hash = "sha256-GqrwhJ4Fyxk4vzOSkFPoxvq5EV50YejaB84m2K006Bc=";
  };

  meta = {
    description = "Simple rsync plugin for yazi file manager";
    homepage = "https://github.com/GianniBYoung/rsync.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
