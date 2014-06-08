{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmpeg2-0.5.1p4";
  
  src = fetchurl {
    url = "http://libmpeg2.sourceforge.net/files/${name}.tar.gz";
    sha256 = "1m3i322n2fwgrvbs1yck7g5md1dbg22bhq5xdqmjpz5m7j4jxqny";
  };

  # From Handbrake - Project seems unmaintained
  patches = [
    ./A00-tags.patch
  ];

  meta = {
    homepage = http://libmpeg2.sourceforge.net/;
    description = "A free library for decoding mpeg-2 and mpeg-1 video streams";
  };
}
