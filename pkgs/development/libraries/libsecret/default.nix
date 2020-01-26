{ stdenv, fetchurl, fetchpatch, glib, pkgconfig, gettext, libxslt, python3
, docbook_xsl, docbook_xml_dtd_42 , libgcrypt, gobject-introspection, vala
, gtk-doc, gnome3, gjs, libintl, dbus, xvfb_run }:

stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.20.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hxfpm8f4rlx685igd4bv89wb80v2952h373g3w6l42kniq7667i";
  };

  patches = [
    (fetchpatch {
      name = "rename-internal-functions-to-avoid-conflicts-and-fix-build.patch";
      url = "https://gitlab.gnome.org/GNOME/libsecret/commit/cf21ad50b62f7c8e4b22ef374f0a73290a99bdb8.patch";
      sha256 = "1n9nyzq5qrvw7s6sj5gzj33ia3rrx719jpys1cfhfbayg2sxyd4n";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  outputs = [ "out" "dev" "devdoc" ];

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [
    pkgconfig gettext libxslt docbook_xsl docbook_xml_dtd_42 libintl
    gobject-introspection vala gtk-doc
  ];
  buildInputs = [ libgcrypt ];
  # optional: build docs with gtk-doc? (probably needs a flag as well)

  configureFlags = [
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
  ];

  enableParallelBuilding = true;

  installCheckInputs = [
    python3 python3.pkgs.dbus-python python3.pkgs.pygobject3 xvfb_run dbus gjs
  ];

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
      # Does not seem to use the odd-unstable policy: https://gitlab.gnome.org/GNOME/libsecret/issues/30
      versionPolicy = "none";
    };
  };

  meta = {
    description = "A library for storing and retrieving passwords and other secrets";
    homepage = https://wiki.gnome.org/Projects/Libsecret;
    license = stdenv.lib.licenses.lgpl21Plus;
    inherit (glib.meta) platforms maintainers;
  };
}
