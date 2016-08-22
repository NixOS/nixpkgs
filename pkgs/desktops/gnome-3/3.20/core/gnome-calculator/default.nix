{ stdenv, intltool, fetchurl, pkgconfig, libxml2
, bash, gtk3, glib, wrapGAppsHook
, autoreconfHook
, itstool, gnome3, librsvg, gdk_pixbuf, mpfr, gmp, libsoup }:

let
  # work-around for https://github.com/NixOS/nixpkgs/issues/17912
  glib-hacked = (glib.overrideDerivation (attrs: {
    postPatch = attrs.postPatch or "" + ''
      cat '${rPatch}' | sed '/^---.*gitignore/,/^---/d' | patch -R -p1
    '';
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
  })).dev; # we need just bin/glib-compile-resources; everything else should be the same
  rPatch = fetchurl {
    name = "glib-resources.patch";
    url = "https://bug673101.bugzilla-attachments.gnome.org/attachment.cgi?"
      + "id=329105&action=diff&collapsed=&context=patch&format=raw&headers=1";
    sha256 = "051d7l1wx9sp5wcnv7yk6mbn3akac1m06sp3jl3hqapx74bkmai0";
  };
in
stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ glib-hacked bash gtk3 glib intltool itstool
                  libxml2 gnome3.gtksourceview mpfr gmp
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings_desktop_schemas gnome3.dconf libsoup ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
