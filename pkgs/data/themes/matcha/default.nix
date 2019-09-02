{ stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "matcha";
  version = "2019-06-22";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "matcha";
    rev = "f42df7a3219d7fbacb7be1b2e0e416d74339865e";
    sha256 = "1x954rmxv14xndn4ybhbr4pmzccnwqp462bpvzd2hak5wsqs4wxc";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

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
