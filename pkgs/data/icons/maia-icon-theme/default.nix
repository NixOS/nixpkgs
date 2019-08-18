{ stdenv, fetchFromGitLab, cmake, extra-cmake-modules, gtk3, kdeFrameworks, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "maia-icon-theme";
  version = "2018-02-24";

  src = fetchFromGitLab {
    domain = "gitlab.manjaro.org";
    group = "artwork";
    owner = "themes";
    repo = "maia";
    rev = "b61312cc80cb9d12b0d8a55b3e61668eb6b77d2d";
    sha256 = "1g98snlh96z4sqw9sfd7fxgamh45pcj3lh1kcmng7mirvrcn2pam";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gtk3
    kdeFrameworks.plasma-framework
    kdeFrameworks.kwindowsystem
  ];

  buildInputs = [
    hicolor-icon-theme
  ];

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Icons based on Breeze and Super Flat Remix";
    homepage = https://gitlab.manjaro.org/artwork/themes/maia;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ mounium ];
    platforms = platforms.all;
  };
}
