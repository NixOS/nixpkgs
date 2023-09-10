{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gobject-introspection, vala, gtk-doc, docbook_xsl, glib, mesonEmulatorHook }:

# TODO: Add installed tests once https://gitlab.gnome.org/World/libcloudproviders/issues/4 is fixed

stdenv.mkDerivation rec {
  pname = "libcloudproviders";
  version = "0.3.1";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/${pname}/repository/archive.tar.gz?ref=${version}";
    sha256 = "0zazjhj3xbwxyzi2b2aws7qdnwn092zg9yrk9v3wd19m3mxq5na3";
  };

  outputs = [ "out" "dev" "devdoc" ];

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [ glib ];

  meta = with lib; {
    description = "DBus API that allows cloud storage sync clients to expose their services";
    homepage = "https://gitlab.gnome.org/World/libcloudproviders";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
