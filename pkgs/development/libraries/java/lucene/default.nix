{stdenv, fetchurl} :

stdenv.mkDerivation rec {
  name = "lucene-${version}";
  version = "1.4.3";

  builder = ./builder.sh;

  src = fetchurl {
    url = "https://archive.apache.org/dist/jakarta/lucene/${name}.tar.gz";
    sha256 = "1mxaxg65f7v8n60irjwm24v7hcisbl0srmpvcy1l4scs6rjj1awh";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
