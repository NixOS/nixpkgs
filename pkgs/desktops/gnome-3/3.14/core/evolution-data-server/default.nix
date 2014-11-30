{ fetchurl, stdenv, pkgconfig, gnome3, python
, intltool, libsoup, libxml2, libsecret, icu
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true, vala }:


stdenv.mkDerivation rec {
  name = "evolution-data-server-3.12.8";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/3.12/${name}.tar.xz";
    sha256 = "06fb4b9a1137b77a53e94eb69e4aeedd8f92d1bd1cfa0175f607660dd3b30818";
  };

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts
      gcr p11_kit libgweather libgdata gperf makeWrapper icu ]
    ++ stdenv.lib.optional valaSupport vala;

  propagatedBuildInputs = [ libsecret nss nspr libical db ];

  # uoa irrelevant for now
  configureFlags = [ "--disable-uoa" ]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
