{ lib, stdenv, fetchFromGitLab, meson, ninja, pkg-config, gobject-introspection, vala
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, gtk3, gnome3
, dbus, xvfb_run, libxml2
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "libhandy";
  version = "0.0.13";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y23k623sjkldfrdiwfarpchg5mg58smcy1pkgnwfwca15wm1ra5";
  };

  nativeBuildInputs = [
    meson ninja pkg-config gobject-introspection vala libxml2
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gnome3.gnome-desktop gtk3 libxml2 ];
  checkInputs = [ dbus xvfb_run hicolor-icon-theme ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dglade_catalog=disabled"
    "-Dintrospection=enabled"
  ];

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${hicolor-icon-theme}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with lib; {
    description = "A library full of GTK widgets for mobile phones";
    homepage = "https://source.puri.sm/Librem5/libhandy";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
