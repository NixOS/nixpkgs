{ stdenv, fetchFromGitHub, meson, ninja, sassc, gdk-pixbuf, librsvg, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "zuki-themes";
  version = "3.36-2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "02gfik9g6kkwcf9h2xlb9nbniajkczhj1xzdnsyk5rlabbvllxcd";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gdk-pixbuf librsvg gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with stdenv.lib; {
    description = "Themes for GTK, gnome-shell and Xfce";
    homepage = "https://github.com/lassekongo83/zuki-themes";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
