{stdenv, fetchurl} :

stdenv.mkDerivation rec {
  pname = "lucene";
  version = "1.4.3";

  builder = ./builder.sh;

  src = fetchurl {
    url = "https://archive.apache.org/dist/jakarta/lucene/${pname}-${version}.tar.gz";
    sha256 = "1mxaxg65f7v8n60irjwm24v7hcisbl0srmpvcy1l4scs6rjj1awh";
  };

  meta = with stdenv.lib; {
    description = "Java full-text search engine";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
