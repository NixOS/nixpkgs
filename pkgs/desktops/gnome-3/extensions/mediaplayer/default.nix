{ stdenv, fetchFromGitHub, glib, meson, gettext, ninja, python3 }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-mediaplayer-${version}";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "JasonLG1979";
    repo = "gnome-shell-extensions-mediaplayer";
    rev = version;
    sha256 = "0b8smid9vdybgs0601q9chlbgfm1rzrj3vmd3i6p2a5d1n4fyvsc";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
  ];
  buildInputs = [
    glib
    gettext
  ];

  postPatch = ''
    rm build
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Control MPRIS Version 2 Capable Media Players";
    license = licenses.gpl2Plus;
    homepage = https://github.com/JasonLG1979/gnome-shell-extensions-mediaplayer/;
    maintainers = with maintainers; [ tiramiseb ];
  };
}

