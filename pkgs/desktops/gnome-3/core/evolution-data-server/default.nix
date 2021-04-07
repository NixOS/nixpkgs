{ fetchurl, lib, stdenv, substituteAll, pkg-config, gnome3, python3, gobject-introspection
, intltool, libsoup, libxml2, libsecret, icu, sqlite, tzdata, libcanberra-gtk3, gcr, p11-kit
, db, nspr, nss, libical, gperf, wrapGAppsHook, glib-networking, pcre, vala, cmake, ninja
, libkrb5, openldap, webkitgtk, libaccounts-glib, json-glib, glib, gtk3, libphonenumber
, gnome-online-accounts, libgweather, libgdata, gsettings-desktop-schemas, boost, protobuf }:

stdenv.mkDerivation rec {
  pname = "evolution-data-server";
  version = "3.38.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "rFPxay1R8+f/gCX5yhn0otTOOEHXKun+K7iX3ICZ1wU=";
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
    cmake ninja pkg-config intltool python3 gperf wrapGAppsHook gobject-introspection vala
  ];
  buildInputs = [
    glib libsoup libxml2 gtk3 gnome-online-accounts
    gcr p11-kit libgweather libgdata libaccounts-glib json-glib
    icu sqlite libkrb5 openldap webkitgtk glib-networking
    libcanberra-gtk3 pcre libphonenumber boost protobuf
  ];

  propagatedBuildInputs = [ libsecret nss nspr libical db libsoup ];

  cmakeFlags = [
    "-DENABLE_UOA=OFF"
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
    "-DWITH_PHONENUMBER=ON"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution-data-server";
    };
  };

  meta = with lib; {
    description = "Unified backend for programs that work with contacts, tasks, and calendar information";
    homepage = "https://wiki.gnome.org/Apps/Evolution";
    license = licenses.lgpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
