{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.6";
  debversion = "3";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "136nf1rj9dp5jgv1p7z4dk0xy3wki1w0vfjbk82f645m0w4samsd";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  patches = let p = "https://sources.debian.net/data/main/t/tiff/${version}-${debversion}/debian/patches"; in [
    (fetchurl {
      url = "${p}/01-CVE-2015-8665_and_CVE-2015-8683.patch";
      sha256 = "0qiiqpbbsf01b59x01z38cg14pmg1ggcsqm9n1gsld6rr5wm3ryz";
    })
    (fetchurl {
      url = "${p}/02-fix_potential_out-of-bound_writes_in_decode_functions.patch";
      sha256 = "1ph057w302i2s94rhdw6ksyvpsmg1nlanvc0251x01s23gkdbakv";
    })
    (fetchurl {
      url = "${p}/03-fix_potential_out-of-bound_write_in_NeXTDecode.patch";
      sha256 = "1nhjg2gdvyzi4wa2g7nwmzm7nssz9dpdfkwms1rp8i1034qdlgc6";
    })
    (fetchurl {
      url = "${p}/04-CVE-2016-5314_CVE-2016-5316_CVE-2016-5320_CVE-2016-5875.patch";
      sha256 = "0n47yk9wcvc9j72yvm5bhpaqq0yfz8jnq9zxbnzx5id9gdxmrkn3";
    })
    (fetchurl {
      url = "${p}/05-CVE-2016-6223.patch";
      sha256 = "0r80hil9k6scdjppgyljhm0s2z6c8cm259f0ic0xvxidfaim6g2r";
    })
    (fetchurl {
      url = "${p}/06-CVE-2016-5321.patch";
      sha256 = "1aacymlqv6cam8i4nbma9v05r3v3xjpagns7q0ii268h0mhzq6qg";
    })
    (fetchurl {
      url = "${p}/07-CVE-2016-5323.patch";
      sha256 = "1xr5hy2fxa71j3fcc1l998pxyblv207ygzyhibwb1lia5zjgblch";
    })
    (fetchurl {
      url = "${p}/08-CVE-2016-3623_CVE-2016-3624.patch";
      sha256 = "1xnvwjvgyxi387h1sdiyp4360a3176jmipb7ghm8vwiz7cisdn9z";
    })
    (fetchurl {
      url = "${p}/09-CVE-2016-5652.patch";
      sha256 = "1yqfq32gzh21ab2jfqkq13gaz0nin0492l06adzsyhr5brvdhnx8";
    })
    (fetchurl {
      url = "${p}/10-CVE-2016-3658.patch";
      sha256 = "01kb8rfk30fgjf1hy0m088yhjfld1yyh4bk3gkg8jx3dl9bd076d";
    })
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.remotesensing.org/libtiff/;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
