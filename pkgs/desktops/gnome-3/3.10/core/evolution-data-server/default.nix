{ fetchurl, stdenv, pkgconfig, gnome3, python, intltool, libsoup, libxml2, libsecret
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true, vala }:


stdenv.mkDerivation rec {
  name = "evolution-data-server-3.10.4";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/3.10/${name}.tar.xz";
    sha256 = "5c2d5e19af19ecfa81f31306411ab6155c3c62cf407d5a5aaa675a8ce940fa2d";
  };

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts libsecret
      gcr p11_kit db nspr nss libgweather libical libgdata gperf makeWrapper ]
    ++ stdenv.lib.optional valaSupport vala;

  # uoa irrelevant for now
  configureFlags = ["--disable-uoa" "--with-nspr-includes=${nspr}/include/nspr" "--with-nss-includes=${nss}/include/nss"]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  preFixup = ''
    for f in "$out/libexec/evolution-addressbook-factory" "$out/libexec/evolution-calendar-factory"; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
