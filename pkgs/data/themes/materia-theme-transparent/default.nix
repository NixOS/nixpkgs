{
  lib,
  fetchFromGitHub,
  materia-theme,
}:
materia-theme.overrideAttrs (oldAttrs: rec {
  pname = "materia-theme-transparent";
  version = "20210322";

  src = fetchFromGitHub {
    owner = "ckissane";
    repo = pname;
    rev = "c5d95bb";
    sha256 = "sha256-dHcwPTZFWO42wu1LbtGCMm2w/YHbjSUJnRKcaFllUbs=";
  };

  meta = with lib; {
    description = "Materia Transparent is a Material Design theme for GNOME/GTK based desktop environments.";
    homepage = "https://github.com/ckissane/materia-theme-transparent";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.corbinwunderlich ];
  };
})
