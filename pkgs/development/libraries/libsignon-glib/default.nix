{ stdenv, fetchgit, pkgconfig, meson, ninja, vala, python3, gtk-doc, docbook_xsl, docbook_xml_dtd_43, docbook_xml_dtd_412, glib, check, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "libsignon-glib";
  version = "unstable-2018-10-24";

  outputs = [ "out" "dev" "devdoc" "py" ];

  src = fetchgit {
    url = "https://gitlab.com/accounts-sso/${pname}";
    rev = "3639a2e90447e4640a03a44972560afe8f61aa48";
    fetchSubmodules = true;
    sha256 = "1cq19zbsx4c57dc5gp3shp8lzcr1hw2ynylpn1nkvfyyrx80m60w";
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
    pkgconfig
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

  meta = with stdenv.lib; {
    description = ''
      A library for managing single signon credentials which can be used from GLib applications
    '';
    homepage = https://gitlab.com/accounts-sso/libsignon-glib;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}

