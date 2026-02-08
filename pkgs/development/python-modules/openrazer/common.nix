{ lib, fetchFromGitHub }:
rec {
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-pk3nghd16jhdf7zokwMzBGwGtBU7ta4nSHsOoGxjD4w=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = lib.platforms.linux;
  };
}
