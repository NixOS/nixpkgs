{ lib, fetchFromGitHub }:
rec {
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-MLwhqLPWdjg1ZUZP5Sig37RgZEeHlU+DyELpyMif6iY=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ] ++ lib.teams.lumiguide.members;
    platforms = lib.platforms.linux;
  };
}
