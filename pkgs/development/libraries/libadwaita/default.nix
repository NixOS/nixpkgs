{ lib
, stdenv
, fetchFromGitLab
, docbook-xsl-nons
, gtk-doc
, meson
, ninja
, pkg-config
, sassc
, vala
, gobject-introspection
, gtk4
, xvfb_run
}:

stdenv.mkDerivation rec {
  pname = "libadwaita";
  version = "unstable-2021-05-01";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = "8d66b987a19979d9d7b85dacc6bad5ce0c8743fe";
    sha256 = "0i3wav6jsyi4w4i2r1rad769m5y5s9djj4zqb7dfyh0bad24ba3q";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gtk-doc
    meson
    ninja
    pkg-config
    sassc
    vala
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  buildInputs = [
    gobject-introspection
    gtk4
  ];

  checkInputs = [
    xvfb_run
  ];

  doCheck = true;

  checkPhase = ''
    xvfb-run meson test
  '';

  meta = with lib; {
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
