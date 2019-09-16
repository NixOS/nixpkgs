{ stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "matcha";
  version = "2019-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jv7qq4lsjpz40wchrqlzc8w4ggrmwjavy4ipzz11jal99skpv7i";
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
