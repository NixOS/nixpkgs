{ stdenv
, fetchFromGitHub
, meson
, ninja
, gdk-pixbuf
, gtk_engines
, gtk-engine-murrine
, librsvg
, sassc
}:

stdenv.mkDerivation rec {
  pname = "plano-theme";
  version = "3.36-1";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rngn5a7hwjqpznbg5kvgs237d2q1anywg37k1cz153ipa96snrv";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  buildInputs = [
    gdk-pixbuf
    gtk_engines
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = with stdenv.lib; {
    description = "Flat theme for GNOME and Xfce";
    homepage = "https://github.com/lassekongo83/plano-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
