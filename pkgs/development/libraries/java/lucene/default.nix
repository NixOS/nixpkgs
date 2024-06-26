{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "lucene";
  version = "1.4.3";

  src = fetchurl {
    url = "https://archive.apache.org/dist/jakarta/lucene/lucene-${version}.tar.gz";
    sha256 = "1mxaxg65f7v8n60irjwm24v7hcisbl0srmpvcy1l4scs6rjj1awh";
  };

  buildCommand = ''
    cp -r . $out/
  '';

  meta = with lib; {
    description = "Java full-text search engine";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
