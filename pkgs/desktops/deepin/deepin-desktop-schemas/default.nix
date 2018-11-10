{ stdenv, fetchFromGitHub, python, deepin-gtk-theme,
deepin-icon-theme, deepin-sound-theme, deepin-wallpapers, gnome3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-schemas";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1vczcb3hvbx2przvw7cdhqcblqhx715dqzsdy2cmkdnanhf84v5z";
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
