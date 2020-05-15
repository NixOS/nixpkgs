{ stdenv, fetchFromGitHub, gdk-pixbuf, gtk_engines, gtk-engine-murrine, librsvg }:

stdenv.mkDerivation rec {
  pname = "plano-theme";
  version = "3.34-2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "0spbyvzb47vyfhcn3gr0z1gdb5xrprynm6442y1z32znai2bgpnd";
  };

  buildInputs = [ gdk-pixbuf gtk_engines librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Plano
    cp -a * $out/share/themes/Plano/
    rm $out/share/themes/Plano/{LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Flat theme for GNOME and Xfce";
    homepage = "https://github.com/lassekongo83/plano-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
