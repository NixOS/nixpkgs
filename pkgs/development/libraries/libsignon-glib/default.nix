{ lib, stdenv, fetchgit, nix-update-script, pkg-config, meson, ninja, vala, python3, gtk-doc, docbook_xsl, docbook_xml_dtd_43, docbook_xml_dtd_412, glib, check, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "libsignon-glib";
  version = "2.1";

  outputs = [ "out" "dev" "devdoc" "py" ];

  src = fetchgit {
    url = "https://gitlab.com/accounts-sso/${pname}";
    rev = "refs/tags/${version}";
    sha256 = "0gnx9gqsh0hcfm1lk7w60g64mkn1iicga5f5xcy1j9a9byacsfd0";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    check
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    glib
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dintrospection=true"
    "-Dpy-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  postPatch = ''
    chmod +x build-aux/gen-error-map.py
    patchShebangs build-aux/gen-error-map.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Library for managing single signon credentials which can be used from GLib applications";
    homepage = "https://gitlab.com/accounts-sso/libsignon-glib";
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

