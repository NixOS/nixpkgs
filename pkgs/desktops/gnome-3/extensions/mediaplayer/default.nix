{ stdenv, fetchFromGitHub, glib, meson, gettext, ninja, python3 }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-mediaplayer-${version}";
  version = "unstable-2019-03-21";

  src = fetchFromGitHub {
    owner = "JasonLG1979";
    repo = "gnome-shell-extensions-mediaplayer";
    rev = "b382c98481fa421501684e2ff3eafc53971ef22b";
    sha256 = "01z2dml8dvl5sljw62g7x19mz02dz1g4gkmyp0h5bx49djcw1nnh";
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

