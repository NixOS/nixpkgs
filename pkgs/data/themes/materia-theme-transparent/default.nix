{ lib, stdenv, fetchFromGitHub, meson, ninja, sassc, gnome-shell, gnome-themes-extra, gtk-engine-murrine, gdk-pixbuf, librsvg }:
stdenv.mkDerivation rec {
  pname = "materia-theme-transparent";
  version = "20210322";

  src = fetchFromGitHub {
    owner = "ckissane";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dHcwPTZFWO42wu1LbtGCMm2w/YHbjSUJnRKcaFllUbs=";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gnome-themes-extra gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  mesonFlags = [ "-Dgnome_shell_version=${lib.versions.majorMinor gnome-shell.version}" ];

  meta = with lib; {
    description = "Materia Transparent is a Material Design theme for GNOME/GTK based desktop environments.";
    homepage = "https://github.com/ckissane/materia-theme-transparent";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.corbinwunderlich ];
  };
}
