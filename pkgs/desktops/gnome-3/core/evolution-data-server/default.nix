{ fetchurl, stdenv, pkgconfig, gnome3, python, intltool, libsoup, libxml2, libsecret
, p11_kit, db, nspr, nss, libical, gperf, valaSupport ? true, vala }:


stdenv.mkDerivation rec {
  name = "evolution-data-server-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/3.10/${name}.tar.xz";
    sha256 = "1fgchc1gzrhhzgn4zf9par4yz72m82j871kf7pky458mh4c4sf0g";
  };

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts libsecret
      gcr p11_kit db nspr nss libgweather libical libgdata gperf ]
    ++ stdenv.lib.optional valaSupport vala;

  # uoa irrelevant for now
  configureFlags = ["--disable-uoa" "--with-nspr-includes=${nspr}/include/nspr" "--with-nss-includes=${nss}/include/nss"]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  installFlags = "gsettingsschemadir=\${out}/share/evolution-data-server/glib-2.0/schemas/";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
