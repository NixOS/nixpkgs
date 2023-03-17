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
  version = "4.0";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-slGr2nsdKng6zaVDeXWFAWKIxZbcnOLU6RH6wM0293E=";
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
