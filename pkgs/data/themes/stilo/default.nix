{ stdenv, fetchFromGitHub, meson, ninja, sassc, gdk-pixbuf, librsvg, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "stilo-themes";
  version = "3.34-2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i5cl61dk8sxa6h61ghynm4wp1qzp3c7kwf4ks0ddzzk9dbvdrhb";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gdk-pixbuf librsvg gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with stdenv.lib; {
    description = "Minimalistic GTK, gnome shell and Xfce themes";
    homepage = "https://github.com/lassekongo83/stilo-themes";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
