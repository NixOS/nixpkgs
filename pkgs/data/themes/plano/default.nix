{ stdenv, fetchFromGitHub, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "plano-theme";
  version = "3.30-3";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rb9whr5r2pj6fmwa9g0vdrfki3dqldnx85mpyq07jvxkipcdq6g";
  };

  buildInputs = [ gdk_pixbuf gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Plano
    cp -a * $out/share/themes/Plano/
    rm $out/share/themes/Plano/LICENSE
  '';

  meta = with stdenv.lib; {
    description = "Flat theme for GNOME & Xfce4";
    homepage = https://github.com/lassekongo83/plano-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
