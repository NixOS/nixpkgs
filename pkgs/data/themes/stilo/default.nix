{ stdenv, fetchFromGitHub, meson, ninja, sassc, gdk-pixbuf, librsvg, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "stilo-themes";
  version = "3.36-3";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "0haxzqxyfx3rc305w7f744fp2xb6j7yn28ldynnvmm47h7ga3as3";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gdk-pixbuf librsvg gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with stdenv.lib; {
    description = "Minimalistic GTK, gnome shell and Xfce themes";
    homepage = "https://github.com/lassekongo83/stilo-themes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
