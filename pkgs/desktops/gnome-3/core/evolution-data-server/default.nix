{ fetchurl, stdenv, substituteAll, pkgconfig, gnome3, python3, gobjectIntrospection
, intltool, libsoup, libxml2, libsecret, icu, sqlite, tzdata
, p11-kit, db, nspr, nss, libical, gperf, wrapGAppsHook, glib-networking
, vala, cmake, ninja, kerberos, openldap, webkitgtk, libaccounts-glib, json-glib }:

stdenv.mkDerivation rec {
  name = "evolution-data-server-${version}";
  version = "3.28.5";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1247gv0ggwnd1i2n7iglb3crfapx6s9nrl896bzy9k87fb94hlyr";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [
    cmake ninja pkgconfig intltool python3 gperf wrapGAppsHook gobjectIntrospection vala
  ];
  buildInputs = with gnome3; [
    glib libsoup libxml2 gtk gnome-online-accounts
    gcr p11-kit libgweather libgdata libaccounts-glib json-glib
    icu sqlite kerberos openldap webkitgtk glib-networking
  ];

  propagatedBuildInputs = [ libsecret nss nspr libical db ];

  cmakeFlags = [
    "-DENABLE_UOA=OFF"
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
  ];


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
