{ stdenv, fetchurl, intltool, pkgconfig, gobjectIntrospection
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib }:

let
  pname = "tracker";
  version = "2.0.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1005w90vhk1cl8g6kxpy2vdzbskw2jskfjcl42lngv18q5sb4bss";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ vala pkgconfig intltool libxslt wrapGAppsHook gobjectIntrospection ];
  # TODO: add libstemmer
  buildInputs = [
    glib libxml2 sqlite upower icu networkmanager libsoup libuuid json-glib
  ];

  # TODO: figure out wrapping unit tests, some of them fail on missing gsettings-desktop-schemas
  configureFlags = [ "--disable-unit-tests" ];

  postPatch = ''
    patchShebangs utils/g-ir-merge/g-ir-merge
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
