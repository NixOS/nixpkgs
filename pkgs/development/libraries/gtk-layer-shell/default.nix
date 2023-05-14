{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, wayland-scanner
, wayland
, gtk3
, gobject-introspection
, vala
}:

stdenv.mkDerivation rec {
  pname = "gtk-layer-shell";
  version = "0.8.0";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # for demo

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk-layer-shell";
    rev = "v${version}";
    sha256 = "sha256-Z7jPYLKgkwMNXu80aaZ2vNj57LbN+X2XqlTTq6l0wTE=";
  };

  patches = [
    # https://github.com/wmww/gtk-layer-shell/pull/146
    # Mark wayland-scanner as a build-time dependency
    (fetchpatch {
      url = "https://github.com/wmww/gtk-layer-shell/commit/6fd16352e5b35fefc91aa44e73671addaaa95dfc.patch";
      hash = "sha256-U/mxmcRcZnsF0fvWW0axo6ajqW40NuOzNIAzoLCboRM=";
    })
    # https://github.com/wmww/gtk-layer-shell/pull/147
    # Remove redundant dependency check for gtk-doc
    (fetchpatch {
      url = "https://github.com/wmww/gtk-layer-shell/commit/124ccc2772d5ecbb40b54872c22e594c74bd39bc.patch";
      hash = "sha256-WfrWe9UJCp1RvVJhURAxGw4jzqPjoaP6182jVdoEAQs=";
    })
  ];

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
    gtk3
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dexamples=true"
  ];

  meta = with lib; {
    description = "A library to create panels and other desktop components for Wayland using the Layer Shell protocol";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ eonpatapon ];
    platforms = platforms.linux;
  };
}
