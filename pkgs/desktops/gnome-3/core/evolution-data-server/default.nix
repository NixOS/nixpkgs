{ fetchurl, stdenv, pkgconfig, gnome3, python3, dconf, gobjectIntrospection
, intltool, libsoup, libxml2, libsecret, icu, sqlite
, p11-kit, db, nspr, nss, libical, gperf, makeWrapper
, vala, cmake, ninja, kerberos, openldap, webkitgtk, libaccounts-glib, json-glib }:

stdenv.mkDerivation rec {
  name = "evolution-data-server-${version}";
  version = "3.28.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1ybyyy6nls11az8lbri1y9527snz5h7qbhyfqvk0vc6vzvald5gv";
  };

  nativeBuildInputs = [
    cmake ninja pkgconfig intltool python3 gperf makeWrapper gobjectIntrospection vala
  ];
  buildInputs = with gnome3; [
    glib libsoup libxml2 gtk gnome-online-accounts
    gcr p11-kit libgweather libgdata libaccounts-glib json-glib
    icu sqlite kerberos openldap webkitgtk
  ];

  propagatedBuildInputs = [ libsecret nss nspr libical db ];

  cmakeFlags = [
    "-DENABLE_UOA=OFF"
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ];


  preFixup = ''
    for f in $(find $out/libexec/ -type f -executable); do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
    done
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
