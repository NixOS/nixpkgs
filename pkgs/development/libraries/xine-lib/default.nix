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
  name = "xine-lib-1-pre-rc7";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/xine/xine-lib-1-rc7.tar.gz;
    md5 = "b3eaa0dd44fdbb8e3915399895c8414a";
  };
  buildInputs = [
    x11
    (if xvideoSupport then libXv else null)
    (if xineramaSupport then libXinerama else null)
    (if alsaSupport then alsaLib else null)
  ];
  libdvdcss = if encryptedDVDSupport then libdvdcss else null;
  propagatedBuildInputs = [zlib];
}
