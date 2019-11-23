{ stdenv, fetchFromGitHub, gdk-pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "plano-theme";
  version = "3.34-1";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fdg4jyc3xv98yg2r6c8rccvbpf8y2l3x79qbpiq6ck9k6d34ycq";
  };

  buildInputs = [ gdk-pixbuf gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Plano
    cp -a * $out/share/themes/Plano/
    rm $out/share/themes/Plano/{COPYING.LGPL-2.1,LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Flat theme for GNOME and Xfce";
    homepage = https://github.com/lassekongo83/plano-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
