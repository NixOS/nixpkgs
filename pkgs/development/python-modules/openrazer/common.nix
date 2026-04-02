{ lib, fetchFromGitHub }:
rec {
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-Sgn+7DABsTnRTx/lh/++JPmfsQ7dM6frkyzG0F5k2gA=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = lib.platforms.linux;
  };
}
