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

stdenv.mkDerivation {
  name = "xine-lib-1.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/xine/xine-lib-1.0.tar.gz;
    md5 = "96e5195c366064e7778af44c3e71f43a";
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
}
