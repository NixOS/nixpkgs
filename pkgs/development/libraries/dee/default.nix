{ stdenv, fetchurl, python, pkgconfig
, glib, icu, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "dee-${version}";
  version = "1.2.7";

  src = fetchurl {
    url = "https://launchpad.net/dee/1.0/${version}/+download/${name}.tar.gz";
    sha256 = "12mzffk0lyd566y46x57jlvb9af152b4dqpasr40zal4wrn37w0v";
  };

  buildInputs = [ glib gobjectIntrospection icu ];
  nativeBuildInputs = [ python pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library that uses DBus to provide objects allowing you to create Model-View-Controller type programs across DBus";
    homepage = "https://launchpad.net/dee";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
