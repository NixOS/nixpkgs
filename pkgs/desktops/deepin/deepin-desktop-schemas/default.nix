{ stdenv, fetchFromGitHub, python, deepin-gtk-theme,
deepin-icon-theme, deepin-sound-theme, deepin-wallpapers, gnome3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-schemas";
  version = "3.2.18.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1siv28wbfjydr3s9k9i5b9fin39yr8ys90f3wi7b8rfm3cr5yy6j";
  };

  nativeBuildInputs = [
    python
  ];

  buildInputs = [
    gnome3.dconf
    deepin-gtk-theme
    deepin-icon-theme
    deepin-sound-theme
    deepin-wallpapers
  ];

  postPatch = ''
    # fix default background url
    sed -i '/picture-uri/s|/usr/share/backgrounds/default_background.jpg|$out/share/backgrounds/deepin/default.png|' \
      overrides/common/com.deepin.wrap.gnome.desktop.override
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "GSettings deepin desktop-wide schemas";
    homepage = https://github.com/linuxdeepin/deepin-desktop-schemas;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
