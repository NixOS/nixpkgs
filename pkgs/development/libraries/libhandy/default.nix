{ stdenv, fetchFromGitLab, meson, ninja, pkgconfig, gobject-introspection, vala
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, gtk3, gnome3
, dbus, xvfb_run, libxml2
}:

let
  pname = "libhandy";
  version = "0.0.5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" "glade" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h25ckdfx3slc2mn4vi06bhw42nrqpzn75i9d7wby9iq0cl13l08";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gobject-introspection vala
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gnome3.gnome-desktop gtk3 gnome3.glade libxml2 ];
  checkInputs = [ dbus xvfb_run ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  PKG_CONFIG_GLADEUI_2_0_MODULEDIR = "${placeholder "glade"}/lib/glade/modules";
  PKG_CONFIG_GLADEUI_2_0_CATALOGDIR = "${placeholder "glade"}/share/glade/catalogs";

  doCheck = true;

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "A library full of GTK+ widgets for mobile phones";
    homepage = https://source.puri.sm/Librem5/libhandy;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
