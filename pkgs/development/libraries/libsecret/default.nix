{ stdenv, fetchurl, glib, pkgconfig, gettext, libxslt, python3, docbook_xsl, docbook_xml_dtd_42
, libgcrypt, gobject-introspection, vala, gtk-doc, gnome3, libintl, dbus, xvfb_run }:

stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.18.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "058x64689k55wxfkdp4svhnwvv8jmqm7z5mrynybl38f4sfqiyiv";
  };

  postPatch = ''
    patchShebangs .
  '';

  outputs = [ "out" "dev" "devdoc" ];

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig gettext libxslt docbook_xsl docbook_xml_dtd_42 libintl gobject-introspection vala gtk-doc ];
  buildInputs = [ libgcrypt ];
  # optional: build docs with gtk-doc? (probably needs a flag as well)

  configureFlags = [
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
  ];

  enableParallelBuilding = true;

  installCheckInputs = [ python3 python3.pkgs.dbus-python python3.pkgs.pygobject3 xvfb_run dbus gnome3.gjs ];

  # needs to run after install because typelibs point to absolute paths
  doInstallCheck = false; # Failed to load shared library '/force/shared/libmock_service.so.0' referenced by the typelib
  installCheckPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "A library for storing and retrieving passwords and other secrets";
    homepage = https://wiki.gnome.org/Projects/Libsecret;
    license = stdenv.lib.licenses.lgpl21Plus;
    inherit (glib.meta) platforms maintainers;
  };
}
