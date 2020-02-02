{ stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "canta-theme";
  version = "2020-01-31";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "070lhbhh3n7nd6rkwm52v1x4v8spyb932w6qmgs2r19g0whyn55w";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    install -D -t $out/share/backgrounds wallpaper/canta-wallpaper.svg
    rm $out/share/themes/*/{AUTHORS,COPYING}
  '';

  meta = with stdenv.lib; {
    description = "Flat Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Canta-theme";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
