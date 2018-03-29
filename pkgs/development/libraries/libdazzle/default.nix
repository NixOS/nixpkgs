{ stdenv, pkgs, fetchurl, ninja, meson, pkgconfig, vala, gobjectIntrospection, libxml2
, gtk-doc, docbook_xsl, dbus, xvfb_run, glib, gtk3, gnome3 }:

let
  version = "3.28.0";
  pname = "libdazzle";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libdazzle/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zq37i7gnmnc7qfngzhj71nqhf2wxl4m247s2ym9ykakxbi6zajp";
  };

  nativeBuildInputs = [ ninja meson pkgconfig vala gobjectIntrospection libxml2 gtk-doc docbook_xsl dbus xvfb_run ];
  buildInputs = [ glib gtk3 ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  doCheck = true;

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library to delight your users with fancy features";
    longDescription = ''
      The libdazzle library is a companion library to GObject and Gtk+. It
      provides various features that we wish were in the underlying library but
      cannot for various reasons. In most cases, they are wildly out of scope
      for those libraries. In other cases, our design isn't quite generic
      enough to work for everyone.
    '';
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
