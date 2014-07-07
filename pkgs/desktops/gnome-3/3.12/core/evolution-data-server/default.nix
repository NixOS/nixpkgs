{ fetchurl, stdenv, pkgconfig, gnome3, python
, intltool, libsoup, libxml2, libsecret, icu
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true, vala }:


stdenv.mkDerivation rec {
  name = "evolution-data-server-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/3.12/${name}.tar.xz";
    sha256 = "91c95e17a8c1cd1086dafcd99a40bdf8f5993770f251f8b0a10e5395e3f5a3b6";
  };

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts libsecret
      gcr p11_kit db nspr nss libgweather libical libgdata gperf makeWrapper icu ]
    ++ stdenv.lib.optional valaSupport vala;

  # uoa irrelevant for now
  configureFlags = ["--disable-uoa" "--with-nspr-includes=${nspr}/include/nspr" "--with-nss-includes=${nss}/include/nss"]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
