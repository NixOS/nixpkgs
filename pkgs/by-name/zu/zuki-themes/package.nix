{ lib, stdenv, fetchFromGitHub, meson, ninja, sassc, gdk-pixbuf, librsvg, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "zuki-themes";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q026wa8xgyb6f5k7pqpm5zav30dbnm3b8w59as3sh8rhfgpbf80";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gdk-pixbuf librsvg gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with lib; {
    description = "Themes for GTK, gnome-shell and Xfce";
    homepage = "https://github.com/lassekongo83/zuki-themes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
