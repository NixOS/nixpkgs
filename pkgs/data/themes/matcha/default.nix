{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "matcha-${version}";
  version = "2019_05_09";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "matcha";
    rev = version;
    sha256 = "0xnv89appivrnbppyjqaa35pls120mkz253p2lblyxzbvi5kgn73";
  };

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./Install -d $out/share/themes
    install -D -t $out/share/gtksourceview-3.0/styles src/extra/gedit/matcha.xml
  '';

  meta = with stdenv.lib; {
    description = "A stylish Design theme for GTK based desktop environments";
    homepage = https://vinceliuice.github.io/theme-matcha;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
