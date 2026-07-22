{ lib, fetchFromGitHub }:
rec {
  version = "3.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-X1NPqbugBdxD5Nt9wIwQADV4CuydGLpgKhlNazVdrIY=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = lib.platforms.linux;
  };
}
