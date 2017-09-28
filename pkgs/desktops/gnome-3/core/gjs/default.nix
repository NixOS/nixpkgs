{ fetchurl, stdenv, pkgconfig, gnome3, gtk3, gobjectIntrospection
, spidermonkey_38, pango, readline, glib, libxml2, dbus }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 gobjectIntrospection gtk3 glib pango readline dbus ];

  propagatedBuildInputs = [ spidermonkey_38 ];

  # GJS expects mozjs-38.pc but spidermonkey_38 only provides js.pc
  preConfigure = ''
    sed -i s/mozjs-38/js/ configure
  '';

  postInstall = ''
    sed 's|-lreadline|-L${readline.out}/lib -lreadline|g' -i $out/lib/libgjs.la
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
