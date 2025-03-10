{ lib, fetchFromGitHub }:
rec {
  version = "3.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-F7lAWM/14texc1PVhch5R2oztcfkoub/9oGdjEmtTZ8=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ] ++ lib.teams.lumiguide.members;
    platforms = lib.platforms.linux;
  };
}
