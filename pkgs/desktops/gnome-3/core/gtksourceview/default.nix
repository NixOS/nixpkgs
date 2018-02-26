{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2, perl, intltool, gettext, gnome3, gobjectIntrospection, dbus, xvfb_run, shared-mime-info }:

let
  checkInputs = [ xvfb_run dbus ];
in stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

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

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  meta = with stdenv.lib; {
    platforms = with platforms; linux ++ darwin;
    maintainers = gnome3.maintainers;
  };
}
