{ stdenv, fetchurl, pkgconfig, glib, gupnp, python, pygobject }:
 
stdenv.mkDerivation rec {
  name = "gupnp-igd-0.2.1";

  src = fetchurl {
    url = https://launchpad.net/ubuntu/+archive/primary/+files/gupnp-igd_0.2.1.orig.tar.gz;
    sha256 = "18ia8l24hbylz3dnbg2jf848bmbx0hjkq4fkwzzfn57z021f0fh2";
  };

  propagatedBuildInputs = [ gupnp ];

  buildInputs = [ glib python pygobject ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.gupnp.org/;
  };
}

