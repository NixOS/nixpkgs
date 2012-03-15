{ stdenv, fetchurl, pkgconfig, glib, gupnp, python, pygobject }:
 
stdenv.mkDerivation rec {
  name = "gupnp-igd-0.2.1";

  src = fetchurl {
    url = "http://www.gupnp.org/sites/all/files/sources/${name}.tar.gz";
    sha256 = "18ia8l24hbylz3dnbg2jf848bmbx0hjkq4fkwzzfn57z021f0fh2";
  };

  propagatedBuildInputs = [ gupnp ];

  buildInputs = [ glib python pygobject ];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.gupnp.org/;
  };
}

