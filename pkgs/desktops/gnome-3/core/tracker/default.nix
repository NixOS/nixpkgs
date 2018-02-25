{ stdenv, fetchurl, intltool, pkgconfig
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  enableParallelBuilding = true;

  nativeBuildInputs = [ vala pkgconfig intltool libxslt wrapGAppsHook ];
  # TODO: add libstemmer
  buildInputs = [
    glib libxml2 sqlite upower icu networkmanager libsoup libuuid json-glib
  ];

  # TODO: figure out wrapping unit tests, some of them fail on missing gsettings-desktop-schemas
  configureFlags = [ "--disable-unit-tests" ];

  postPatch = ''
    patchShebangs utils/g-ir-merge/g-ir-merge
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
