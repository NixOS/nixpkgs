{ stdenv, fetchurl, intltool, pkgconfig
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib }:

stdenv.mkDerivation rec {
  name = "tracker-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "ece71a56c29151a76fc1b6e43c15dd1b657b37162dc948fa2487faf5ddb47fda";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "tracker"; attrPath = "gnome3.tracker"; };
  };

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
