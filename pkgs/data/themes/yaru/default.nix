{ lib
, stdenv
, fetchFromGitHub
, meson
, sassc
, pkg-config
, glib
, ninja
, python3
, gtk3
, gnome
, gtk-engine-murrine
, humanity-icon-theme
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "yaru";
  version = "unstable-2022-04-07"; # 22.04.3.1 is broken

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    rev = "9bdbf66bf3718c6595c7a15ef4698ba471a36526";
    sha256 = "02f6m0jxnsczw3y7v7bqdihxa33sx2z93yn3j8w4z9r9fv2pn06b";
  };

  nativeBuildInputs = [ meson sassc pkg-config glib ninja python3 ];
  buildInputs = [ gtk3 gnome.gnome-themes-extra ];
  propagatedBuildInputs = [ humanity-icon-theme hicolor-icon-theme ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  meta = with lib; {
    description = "Ubuntu community theme 'yaru' - default Ubuntu theme since 18.10";
    homepage = "https://github.com/ubuntu/yaru";
    license = with licenses; [ cc-by-sa-40 gpl3Plus lgpl21Only lgpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fortuneteller2k maxeaubrey ];
  };
}
