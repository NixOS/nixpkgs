{ stdenv, fetchurl, fetchFromGitLab, intltool, meson, ninja, pkgconfig, gobjectIntrospection, python2
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_43, glibcLocales
, libxml2, upower, glib, wrapGAppsHook, vala, sqlite, libxslt, libstemmer
, gnome3, icu, libuuid, networkmanager, libsoup, json-glib }:

let
  pname = "tracker";
  version = "2.1.5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  # tarball does not contain map files
  # https://gitlab.gnome.org/GNOME/tracker/merge_requests/30
  # src = fetchurl {
  #   url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
  #   sha256 = "07l6fb6i4pfna2y87rydcxbh6sz88kngapw87vf09fbk6xbvfd5j";
  # };
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "1wg3pndd0j8qkzn9ikzqlcww8r3bd89ydf6fi4ng5k93879j2bqw";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig intltool libxslt wrapGAppsHook gobjectIntrospection
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_43 glibcLocales
    python2 # for data-generators
  ];

  buildInputs = [
    glib libxml2 sqlite upower icu networkmanager libsoup libuuid json-glib libstemmer
  ];

  LC_ALL = "en_US.UTF-8";

  mesonFlags = [
    "-Ddbus_services=share/dbus-1/services"
    # TODO: figure out wrapping unit tests, some of them fail on missing gsettings-desktop-schemas
    "-Dfunctional_tests=false"
  ];

  postPatch = ''
    patchShebangs utils/g-ir-merge/g-ir-merge
    patchShebangs utils/data-generators/cc/generate
  '';

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
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
