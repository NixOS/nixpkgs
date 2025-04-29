{ lib, fetchFromGitHub }:
rec {
  version = "3.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-igrGx7Y6ENtZatJCTAW43/0q6ZjljJ9/kU3QFli4yIU=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    teams = [ lib.teams.lumiguide ];
    platforms = lib.platforms.linux;
  };
}
