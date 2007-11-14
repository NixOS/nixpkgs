{ xvideoSupport ? true
, xineramaSupport ? true
, encryptedDVDSupport ? true
, alsaSupport ? true
, stdenv, fetchurl, zlib, x11
, libXv ? null, libXinerama ? null, libdvdcss ? null, alsaLib ? null
}:

assert xvideoSupport -> libXv != null;
assert xineramaSupport -> libXinerama != null;
assert encryptedDVDSupport -> libdvdcss != null;
assert alsaSupport -> alsaLib != null;

(stdenv.mkDerivation {
  name = "xine-lib-1.1.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/xine/xine-lib-1.1.8.tar.bz2;
    sha256 = "03iwhgsf9kj0x5b4fgv7lzc1vj3frk4afh2idgrqskvixjyi37vc";
  };
  buildInputs = [
    x11
    (if xvideoSupport then libXv else null)
    (if xineramaSupport then libXinerama else null)
    (if alsaSupport then alsaLib else null)
  ];
  libXv = if xvideoSupport then libXv else null;
  libdvdcss = if encryptedDVDSupport then libdvdcss else null;
  propagatedBuildInputs = [zlib];
}) // {inherit xineramaSupport libXinerama;}
