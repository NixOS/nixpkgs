{ fetchurl, stdenv, pkgconfig, gnome3, python3, dconf
, intltool, libsoup, libxml2, libsecret, icu, sqlite
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true
, vala, cmake, kerberos, openldap, webkitgtk, libaccounts-glib, json_glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [
    cmake pkgconfig intltool python3 gperf makeWrapper
  ] ++ stdenv.lib.optional valaSupport vala;
  buildInputs = with gnome3; [
    glib libsoup libxml2 gtk gnome_online_accounts
    gcr p11_kit libgweather libgdata libaccounts-glib json_glib
    icu sqlite kerberos openldap webkitgtk
  ];

  propagatedBuildInputs = [ libsecret nss nspr libical db ];

  # uoa irrelevant for now
  cmakeFlags = [
    "-DENABLE_UOA=OFF"
  ] ++ stdenv.lib.optionals valaSupport [
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in $(find $out/libexec/ -type f -executable); do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
    done
  '';

  meta = with stdenv.lib; {
    license = licenses.lgpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
