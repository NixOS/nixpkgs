{ lib
, stdenv
, fetchFromGitLab
, docbook-xsl-nons
, gi-docgen
, gtk-doc
, libxml2
, meson
, ninja
, pkg-config
, sassc
, vala
, gobject-introspection
, fribidi
, gtk4
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "libadwaita";
  version = "1.0.0-alpha.1";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = version;
    sha256 = "1v52md62kaqykv8b6kxxbxwnbdzlda4ir7n5wh2iizadcailyw7p";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gi-docgen
    gtk-doc
    libxml2 # for xmllint
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
    fribidi
    gobject-introspection
    gtk4
  ];

  checkInputs = [
    xvfb-run
  ];

  doCheck = true;

  checkPhase = ''
    xvfb-run meson test
  '';

  postInstall = ''
    mv $out/share/{doc,gtk-doc}
  '';

  meta = with lib; {
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
