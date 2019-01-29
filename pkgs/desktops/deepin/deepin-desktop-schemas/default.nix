{ stdenv, fetchFromGitHub, python, deepin-gtk-theme,
  deepin-icon-theme, deepin-sound-theme, deepin-wallpapers, gnome3,
  deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-schemas";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "10x0rh9z925yzyp8h0vgmg4313smvran06lvr12c3931qkmkzwgq";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "GSettings deepin desktop-wide schemas";
    homepage = https://github.com/linuxdeepin/deepin-desktop-schemas;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
