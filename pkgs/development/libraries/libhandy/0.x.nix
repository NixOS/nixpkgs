{ lib, stdenv, fetchFromGitLab, meson, ninja, pkg-config, gobject-introspection, vala
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, gtk3, gnome-desktop
, dbus, xvfb-run, libxml2
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
  buildInputs = [ gnome-desktop gtk3 libxml2 ];
  nativeCheckInputs = [ dbus xvfb-run hicolor-icon-theme ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dglade_catalog=disabled"
    "-Dintrospection=enabled"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${hicolor-icon-theme}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with lib; {
    description = "Library full of GTK widgets for mobile phones";
    mainProgram = "handy-0.0-demo";
    homepage = "https://source.puri.sm/Librem5/libhandy";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
