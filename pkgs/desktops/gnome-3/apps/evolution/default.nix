{ stdenv, cmake, ninja, intltool, fetchurl, libxml2, webkitgtk, highlight
, pkgconfig, gtk3, glib, libnotify, gtkspell3
, wrapGAppsHook, itstool, shared-mime-info, libical, db, gcr, sqlite
, gnome3, librsvg, gdk_pixbuf, libsecret, nss, nspr, icu
, libcanberra-gtk3, bogofilter, gst_all_1, procps, p11-kit, openldap }:

let
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "evolution-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0b6yw664jdfc8ppd78akmrl36iximh7ipknf5mlzgga6lr6pl2nf";
  };

  propagatedUserEnvPkgs = [ gnome3.evolution-data-server ];

  buildInputs = [
    gtk3 glib gdk_pixbuf gnome3.defaultIconTheme librsvg db icu
    gnome3.evolution-data-server libsecret libical gcr
    webkitgtk shared-mime-info gnome3.gnome-desktop gtkspell3
    libcanberra-gtk3 bogofilter gnome3.libgdata sqlite
    gst_all_1.gstreamer gst_all_1.gst-plugins-base p11-kit
    nss nspr libnotify procps highlight gnome3.libgweather
    gnome3.gsettings-desktop-schemas
    gnome3.glib-networking openldap
  ];

  nativeBuildInputs = [ cmake ninja intltool itstool libxml2 pkgconfig wrapGAppsHook ];

  cmakeFlags = [
    "-DENABLE_AUTOAR=OFF"
    "-DENABLE_LIBCRYPTUI=OFF"
    "-DENABLE_YTNEF=OFF"
    "-DENABLE_PST_IMPORT=OFF"
  ];

  doCheck = true;

  checkPhase = "ctest";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution";
      attrPath = "gnome3.evolution";
    };
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Evolution;
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
