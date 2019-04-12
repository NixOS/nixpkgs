{ fetchurl, stdenv, substituteAll, pkgconfig, gnome3, python3, gobject-introspection
, intltool, libsoup, libxml2, libsecret, icu, sqlite, tzdata, libcanberra-gtk3, gcr
, p11-kit, db, nspr, nss, libical, gperf, wrapGAppsHook, glib-networking, pcre
, vala, cmake, ninja, kerberos, openldap, webkitgtk, libaccounts-glib, json-glib
, glib, gtk3, gnome-online-accounts, libgweather, libgdata }:

stdenv.mkDerivation rec {
  name = "evolution-data-server-${version}";
  version = "3.32.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1pnxf0jcbmh86ahkjgn3l2521yvgypgmfz590wp350z4fi4vh44f";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
    ./hardcode-gsettings.patch
  ];

  nativeBuildInputs = [
    cmake ninja pkgconfig intltool python3 gperf wrapGAppsHook gobject-introspection vala
  ];
  buildInputs = [
    glib libsoup libxml2 gtk3 gnome-online-accounts
    gcr p11-kit libgweather libgdata libaccounts-glib json-glib
    icu sqlite kerberos openldap webkitgtk glib-networking
    libcanberra-gtk3 pcre
  ];

  propagatedBuildInputs = [ libsecret nss nspr libical db libsoup ];

  cmakeFlags = [
    "-DENABLE_UOA=OFF"
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
  ];

  postPatch = ''
    substituteInPlace src/libedataserver/e-source-registry.c --subst-var-by ESD_GSETTINGS_PATH $out/share/gsettings-schemas/${name}/glib-2.0/schemas
  '';


  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution-data-server";
    };
  };

  meta = with stdenv.lib; {
    description = "Unified backend for programs that work with contacts, tasks, and calendar information";
    homepage = https://wiki.gnome.org/Apps/Evolution;
    license = licenses.lgpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
