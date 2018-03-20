{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2, perl, intltool, gettext, gnome3, gobjectIntrospection, dbus, xvfb_run, shared-mime-info }:

let
  checkInputs = [ xvfb_run dbus ];
in stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "3.24.6";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "7aa6bdfebcdc73a763dddeaa42f190c40835e6f8495bb9eb8f78587e2577c188";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gtksourceview"; attrPath = "gnome3.gtksourceview"; };
  };

  propagatedBuildInputs = [
    # Required by gtksourceview-3.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig intltool gettext perl gobjectIntrospection ]
    ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [ atk cairo glib pango libxml2 ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c --replace "@NIX_SHARE_PATH@" "$out/share"
  '';

  patches = [ ./nix_share_path.patch ];

  enableParallelBuilding = true;

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GtkSourceView;
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
  };
}
