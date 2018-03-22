{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango, vala_0_40
, libxml2, perl, gettext, gnome3, gobjectIntrospection, dbus, xvfb_run, shared-mime-info }:

let
  checkInputs = [ xvfb_run dbus ];
in stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0amkspjsvxr3rjznmnwjwsgw030hayf6bw49ya4nligslwl7lp3f";
  };

  propagatedBuildInputs = [
    # Required by gtksourceview-4.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gettext perl gobjectIntrospection vala_0_40 ]
    ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [ atk cairo glib pango libxml2 ];

  patches = [ ./4.x-nix_share_path.patch ];

  enableParallelBuilding = true;

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtksourceview";
      attrPath = "gnome3.gtksourceview";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GtkSourceView;
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
  };
}
