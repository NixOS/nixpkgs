{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, wayland-scanner
, wayland
, gtk4
, gobject-introspection
, vala
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk4-layer-shell";
  version = "1.0.1";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc";

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk4-layer-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MG/YW4AhC2joUX93Y/pzV4s8TrCo5Z/I3hAT70jW8dw=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    vala
    wayland-scanner
  ];

  buildInputs = [
    wayland
    gtk4
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dexamples=true"
  ];

  meta = with lib; {
    description = "A library to create panels and other desktop components for Wayland using the Layer Shell protocol and GTK4";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    platforms = platforms.linux;
  };
})
