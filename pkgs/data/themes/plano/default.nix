{ stdenv, fetchFromGitHub, gdk-pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "plano-theme";
  version = "3.32-1";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p9j4p32489jb6d67jhf9x26my0mddcc6a174x713drch8zvb96l";
  };

  buildInputs = [ gdk-pixbuf gtk_engines ];

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
