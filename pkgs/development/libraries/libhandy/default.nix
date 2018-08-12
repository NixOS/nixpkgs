{ stdenv, fetchFromGitLab, fetchpatch, meson, ninja, pkgconfig, gobjectIntrospection, vala
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, gtk3, gnome3
, dbus, xvfb_run, libxml2
}:

let
  pname = "libhandy";
  version = "0.0.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" "glade" ];
  outputBin = "dev";

  patches = [
    # https://source.puri.sm/Librem5/libhandy/merge_requests/158
    (fetchpatch {
      url = https://source.puri.sm/Librem5/libhandy/commit/50865a07a94875f17d5ef04751ea5de80264407c.patch;
      sha256 = "1xg4lb03b97s4wbiqgwhq6p87cmxi464dfv9xpxwm2najaxc66fq";
    })
  ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pxh04irdil90cik2vxw174vmfqvz380s3yqx33pym65h8nah8a8";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gobjectIntrospection vala
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
