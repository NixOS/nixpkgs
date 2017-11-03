{ stdenv, fetchurl, fetchpatch, zlib, imagemagick, libpng, pkgconfig, glib
, freetype, libjpeg, libxml2 }:

stdenv.mkDerivation {
  name = "libwmf-0.2.8.4";

  src = fetchurl {
    url = mirror://sourceforge/wvware/libwmf-0.2.8.4.tar.gz;
    sha256 = "1y3wba4q8pl7kr51212jwrsz1x6nslsx1gsjml1x0i8549lmqd2v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib imagemagick libpng glib freetype libjpeg libxml2 ];

  patches = [
    ./CVE-2006-3376.patch ./CVE-2009-1364.patch
    ./CVE-2015-0848+4588+4695+4696.patch
    (fetchpatch {
      name = "libwmf-0.2.8.4-CVE-2016-9011-debian.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=842090;filename=libwmf-0.2.8.4-CVE-2016-9011-debian.patch;msg=10";
      sha256 = "15vnqrj1dlvn0g8ccrxj2r2cyb1rv0qf0kfangxfgsi5h8is0c2b";
    })
  ];

  meta = {
    description = "WMF library from wvWare";
    platforms = stdenv.lib.platforms.unix;
  };
}
