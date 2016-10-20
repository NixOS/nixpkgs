{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.6";
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

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/01-CVE-2015-8665_and_CVE-2015-8683.patch";
      sha256 = "1c4zmvxj124873al8fvkiv8zq7wx5mv2vd4f1y9w8liv92cm7hkc";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/02-fix_potential_out-of-bound_writes_in_decode_functions.patch";
      sha256 = "0rsc7zh7cdhgcmx2vbjfaqrb0g93a3924ngqkrzb14w5j2fqfbxv";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/03-fix_potential_out-of-bound_write_in_NeXTDecode.patch";
      sha256 = "1s01xhp4sl04yhqhqwp50gh43ykcqk230mmbv62vhy2jh7v0ky3a";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/04-CVE-2016-5314_CVE-2016-5316_CVE-2016-5320_CVE-2016-5875.patch";
      sha256 = "0by35qxpzv9ib3mnh980gd30jf3qmsfp2kl730rq4pq66wpzg9m8";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/05-CVE-2016-6223.patch";
      sha256 = "0rh8ia0wsf5yskzwdjrlbiilc9m0lq0igs42k6922pl3sa1lxzv1";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/06-CVE-2016-5321.patch";
      sha256 = "0n0igfxbd3kqvvj2k2xgysrp63l4v2gd110fwkk4apfpm0hvzwh0";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tiff/4.0.6-2/debian/patches/07-CVE-2016-5323.patch";
      sha256 = "1j6w8g6qizkx5h4aq95kxzx6bgkn4jhc8l22swwhvlkichsh4910";
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
