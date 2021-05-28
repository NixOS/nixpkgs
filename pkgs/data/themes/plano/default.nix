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
  version = "3.36-2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "01dkjck9rlrf8wa30ad7kfv0gbpdf3l05rw7nxrvb1gh5d2vxig9";
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
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
