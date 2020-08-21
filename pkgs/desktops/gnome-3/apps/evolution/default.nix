{ stdenv
, cmake
, ninja
, intltool
, fetchurl
, libxml2
, webkitgtk
, highlight
, pkgconfig
, gtk3
, glib
, libnotify
, gspell
, evolution-data-server
, adwaita-icon-theme
, gnome-desktop
, libgdata
, libgweather
, glib-networking
, gsettings-desktop-schemas
, wrapGAppsHook
, itstool
, shared-mime-info
, libical
, db
, gcr
, sqlite
, gnome3
, librsvg
, gdk-pixbuf
, libsecret
, nss
, nspr
, icu
, libcanberra-gtk3
, bogofilter
, gst_all_1
, procps
, p11-kit
, openldap
, spamassassin
}:

stdenv.mkDerivation rec {
  pname = "evolution";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0pbwjp4bk5bqr90lm5vc609ibs32jfq4xagkljfhabdaah7w877q";
  };

  nativeBuildInputs = [
    cmake
    intltool
    itstool
    libxml2
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    bogofilter
    db
    evolution-data-server
    gcr
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    gspell
    highlight
    icu
    libcanberra-gtk3
    libgdata
    libgweather
    libical
    libnotify
    librsvg
    libsecret
    nspr
    nss
    openldap
    p11-kit
    procps
    shared-mime-info
    sqlite
    webkitgtk
  ];

  propagatedUserEnvPkgs = [
    evolution-data-server
  ];

  cmakeFlags = [
    "-DENABLE_AUTOAR=OFF"
    "-DENABLE_LIBCRYPTUI=OFF"
    "-DENABLE_PST_IMPORT=OFF"
    "-DENABLE_YTNEF=OFF"
    "-DWITH_SPAMASSASSIN=${spamassassin}/bin/spamassassin"
    "-DWITH_SA_LEARN=${spamassassin}/bin/sa-learn"
    "-DWITH_BOGOFILTER=${bogofilter}/bin/bogofilter"
    "-DWITH_OPENLDAP=${openldap}"
  ];

  requiredSystemFeatures = [
    "big-parallel"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution";
      attrPath = "gnome3.evolution";
    };
  };

  PKG_CONFIG_LIBEDATASERVERUI_1_2_UIMODULEDIR = "${placeholder "out"}/lib/evolution-data-server/ui-modules";

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Evolution";
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
