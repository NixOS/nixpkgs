{ fetchurl, stdenv, pkgconfig, gnome3, gtk3, gobjectIntrospection
, spidermonkey_24, pango, readline, glib, libxml2 }:

let
  majorVersion = "1.43";
in
stdenv.mkDerivation rec {
  name = "gjs-${majorVersion}.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${majorVersion}/${name}.tar.xz";
    sha256 = "0khwm8l6m6x71rwf3q92d6scbhmrpiw7kqmj34nn588fb7a4vdc2";
  };

  buildInputs = [ libxml2 gobjectIntrospection pkgconfig gtk3 glib pango readline ];

  propagatedBuildInputs = [ spidermonkey_24 ];

  postInstall = ''
    sed 's|-lreadline|-L${readline}/lib -lreadline|g' -i $out/lib/libgjs.la
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
