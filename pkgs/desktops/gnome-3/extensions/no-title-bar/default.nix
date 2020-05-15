{ stdenv, fetchFromGitHub, substituteAll, glib, gettext, xorg }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-no-title-bar";
  version = "9";

  src = fetchFromGitHub {
    owner = "franglais125";
    repo = "no-title-bar";
    rev = "v${version}";
    sha256 = "02zm61fg40r005fn2rvgrbsz2hbcsmp2hkhyilqbmpilw35y0nbq";
  };

  nativeBuildInputs = [
    glib gettext
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      xprop = "${xorg.xprop}/bin/xprop";
      xwininfo = "${xorg.xwininfo}/bin/xwininfo";
    })
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  uuid = "no-title-bar@franglais125.gmail.com";

  meta = with stdenv.lib; {
    description = "Integrates maximized windows with the top panel";
    homepage = "https://github.com/franglais125/no-title-bar";
    license = licenses.gpl2;
    broken = true; # https://github.com/franglais125/no-title-bar/issues/114
    maintainers = with maintainers; [ jonafato svsdep ];
    platforms = platforms.linux;
  };
}
