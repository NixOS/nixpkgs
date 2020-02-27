{ stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "matcha";
  version = "2020-02-27";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1ngndd8lz1m2c9zm9m0wgnz35mdyrxnxxaxbg09zckqp1nrj4lm9";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    install -D -t $out/share/gtksourceview-3.0/styles src/extra/gedit/matcha.xml
  '';

  meta = with stdenv.lib; {
    description = "A stylish Design theme for GTK based desktop environments";
    homepage = "https://vinceliuice.github.io/theme-matcha";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
