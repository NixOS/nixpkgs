{ lib, stdenv
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
  version = "3.38-1";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g2mwvzc04z3dsdfhwqgw9s7987406pv22s9rbazfvprk4ddc5b6";
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

  meta = with lib; {
    description = "Flat theme for GNOME and Xfce";
    homepage = "https://github.com/lassekongo83/plano-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
