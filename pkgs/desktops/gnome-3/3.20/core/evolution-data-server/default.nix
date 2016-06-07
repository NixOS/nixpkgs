{ fetchurl, stdenv, pkgconfig, gnome3, python
, intltool, libsoup, libxml2, libsecret, icu, sqlite
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true, vala }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts
      gcr p11_kit libgweather libgdata gperf makeWrapper icu sqlite gsettings_desktop_schemas ]
    ++ stdenv.lib.optional valaSupport vala;

  propagatedBuildInputs = [ libsecret nss nspr libical db ];

  # uoa irrelevant for now
  configureFlags = [ "--disable-uoa" "--disable-google-auth" ]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
