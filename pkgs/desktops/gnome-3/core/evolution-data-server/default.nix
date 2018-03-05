{ fetchurl, stdenv, pkgconfig, gnome3, python3, dconf
, intltool, libsoup, libxml2, libsecret, icu, sqlite
, p11-kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true
, vala, cmake, ninja, kerberos, openldap, webkitgtk, libaccounts-glib, json-glib }:

stdenv.mkDerivation rec {
  name = "evolution-data-server-${version}";
  version = "3.26.5";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0m0y4l5wrdxpb6bs929ml7ayicwygfvngrzxf88hn0vkw0crfa9z";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "evolution-data-server"; };
  };

  nativeBuildInputs = [
    cmake ninja pkgconfig intltool python3 gperf makeWrapper
  ] ++ stdenv.lib.optional valaSupport vala;
  buildInputs = with gnome3; [
    glib libsoup libxml2 gtk gnome-online-accounts
    gcr p11-kit libgweather libgdata libaccounts-glib json-glib
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
