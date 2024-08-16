{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, ninja
, meson
, pkg-config
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, gtk3
, graphene
, libepoxy
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gthree";
  version = "0.9.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "alexlarsson";
    repo = "gthree";
    rev = version;
    sha256 = "09fcnjc3j21lh5fjf067wm35sb4qni4vgzing61kixnn2shy79iy";
  };

  patches = [
    # Add option for disabling examples
    (fetchpatch {
      url = "https://github.com/alexlarsson/gthree/commit/75f05c40aba9d5f603d8a3c490c3406c1fe06776.patch";
      sha256 = "PBwLz4DLhC+7BtypVTFMFiF3hKAJeskU3XBKFHa3a84=";
    })
  ];

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    libepoxy
    json-glib
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    graphene
  ];

  mesonFlags = [
    "-Dgtk_doc=${if stdenv.isDarwin then "false" else "true"}"
    # Data for examples is useless when the example programs are not installed.
    "-Dexamples=false"
  ];

  meta = with lib; {
    description = "GObject/GTK port of three.js";
    homepage = "https://github.com/alexlarsson/gthree";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gthree.x86_64-darwin
  };
}
