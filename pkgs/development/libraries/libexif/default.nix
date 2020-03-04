{ stdenv, fetchurl, fetchpatch, gettext }:

stdenv.mkDerivation rec {
  name = "libexif-0.6.21";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "06nlsibr3ylfwp28w8f5466l6drgrnydgxrm4jmxzrmk5svaxk8n";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-7544.patch";
      url = "https://github.com/libexif/libexif/commit/c39acd1692023b26290778a02a9232c873f9d71a.patch";
      sha256 = "0xgx6ly2i4q05shb61mfx6njwf1yp347jkznm0ka4m85i41xm6sd";
    })
    (fetchpatch {
      name = "CVE-2018-20030-1.patch";
      url = "https://github.com/libexif/libexif/commit/5d28011c40ec86cf52cffad541093d37c263898a.patch";
      sha256 = "1wv8s962wmbn2m2xypgirf12g6msrbplpsmd5bh86irfwhkcppj3";
    })
    (fetchpatch {
      name = "CVE-2018-20030-2.patch";
      url = "https://github.com/libexif/libexif/commit/6aa11df549114ebda520dde4cdaea2f9357b2c89.patch";
      sha256 = "01aqvz63glwq6wg0wr7ykqqghb4abgq77ghvhizbzadg1k4h7drx";
      excludes = [ "NEWS" ];
    })
    (fetchpatch {
      name = "CVE-2019-9278.patch";
      url = "https://github.com/libexif/libexif/commit/75aa73267fdb1e0ebfbc00369e7312bac43d0566.patch";
      sha256 = "10ikg33mips5zq9as7l9xqnyzbg1wwr4sw17517nzf4hafjpasrj";
    })
  ];

  buildInputs = [ gettext ];

  meta = {
    homepage = https://libexif.github.io/;
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.erictapen ];
  };

}
