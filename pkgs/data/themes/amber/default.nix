{ lib, stdenv, fetchFromGitHub, meson, ninja, sassc, gdk-pixbuf, librsvg, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "amber-theme";
  version = "3.38-1";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OrdBeAD+gdIu6u8ESE9PtqYadSuJ8nx1Z8fB4D9y4W4=";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gdk-pixbuf librsvg gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with lib; {
    description = "GTK, gnome-shell and Xfce theme based on Ubuntu Ambiance";
    homepage = "https://github.com/lassekongo83/amber-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
