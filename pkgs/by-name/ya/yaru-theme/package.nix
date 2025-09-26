{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  sassc,
  pkg-config,
  glib,
  ninja,
  python3,
  gtk3,
  gnome-themes-extra,
  gtk-engine-murrine,
  humanity-icon-theme,
  hicolor-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "yaru";
  version = "25.10.2";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    rev = version;
    hash = "sha256-3NTqRmAdO3+9e9B7Fe0B9PPeMUBAmin+51cfqAijV0w=";
  };

  nativeBuildInputs = [
    meson
    sassc
    pkg-config
    glib
    ninja
    python3
  ];
  buildInputs = [
    gtk3
    gnome-themes-extra
  ];
  propagatedBuildInputs = [
    humanity-icon-theme
    hicolor-icon-theme
  ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  meta = with lib; {
    description = "Ubuntu community theme 'yaru' - default Ubuntu theme since 18.10";
    homepage = "https://github.com/ubuntu/yaru";
    license = with licenses; [
      cc-by-sa-40
      gpl3Plus
      lgpl21Only
      lgpl3Only
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ moni ];
  };
}
