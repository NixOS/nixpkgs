{ fetchurl, stdenv, substituteAll, pkgconfig, gnome3, python3, gobject-introspection
, intltool, libsoup, libxml2, libsecret, icu, sqlite, tzdata, libcanberra-gtk3, gcr
, p11-kit, db, nspr, nss, libical, gperf, wrapGAppsHook, glib-networking, pcre
, vala, cmake, ninja, kerberos, openldap, webkitgtk, libaccounts-glib, json-glib
, glib, gtk3, gnome-online-accounts, libgweather, libgdata, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "evolution-data-server";
  version = "3.34.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wz8mizblmvficxap6z9w62ymjwa8x99spnaljcwjl1wc55lnp4q";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  prePatch = ''
    substitute ${./hardcode-gsettings.patch} hardcode-gsettings.patch --subst-var-by ESD_GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"} \
      --subst-var-by GDS_GSETTINGS_PATH ${glib.getSchemaPath gsettings-desktop-schemas}
    patches="$patches $PWD/hardcode-gsettings.patch"
  '';

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
