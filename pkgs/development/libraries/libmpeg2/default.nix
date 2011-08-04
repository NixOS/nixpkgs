{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmpeg2-0.5.1";
  
  src = fetchurl {
    url = "http://libmpeg2.sourceforge.net/files/${name}.tar.gz";
    sha256 = "1m3i322n2fwgrvbs1yck7g5md1dbg22bhq5xdqmjpz5m7j4jxqny";
  };

  meta = {
    homepage = http://libmpeg2.sourceforge.net/;
    description = "A free library for decoding mpeg-2 and mpeg-1 video streams";
  };
}
