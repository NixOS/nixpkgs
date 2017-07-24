{ fetchurl, stdenv, pkgconfig, gnome3, python, dconf
, intltool, libsoup, libxml2, libsecret, icu, sqlite
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true, vala_0_32 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts (stdenv.lib.getLib dconf)
      gcr p11_kit libgweather libgdata gperf makeWrapper icu sqlite gsettings_desktop_schemas ]
    ++ stdenv.lib.optional valaSupport vala_0_32;

  propagatedBuildInputs = [ libsecret nss nspr libical db ];

  # uoa irrelevant for now
  configureFlags = [ "--disable-uoa" "--disable-google-auth" ]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  enableParallelBuilding = true;

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
