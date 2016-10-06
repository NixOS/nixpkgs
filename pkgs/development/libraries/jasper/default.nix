{ stdenv, fetchurl, fetchpatch, libjpeg, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "jasper-1.900.2";

  src = fetchurl {
    url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.tar.gz";
    sha256 = "0bkibjhq3js2ldxa2f9pss84lcx4f5d3v0qis3ifi11ciy7a6c9a";
  };

  patches = [
    ./jasper-CVE-2014-8137-variant2.diff
    ./jasper-CVE-2014-8137-noabort.diff

    (fetchpatch { # CVE-2016-2089
      url = "https://github.com/mdadams/jasper/commit/aa6d9c2bbae9155f8e1466295373a68fa97291c3.patch";
      sha256 = "1pxnm86zmbq6brfwsm5wx3iv7s92n4xilc52lzp61q266jmlggrf";
    })
    (fetchpatch { # CVE-2015-5203
      url = "https://github.com/mdadams/jasper/commit/e73bb58f99fec0bf9c5d8866e010fcf736a53b9a.patch";
      sha256 = "1r6hxbnhpnb7q6p2kbdxc1cpph3ic851x2hy477yv5c3qmrbx9bk";
    })
  ];

  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = "--enable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
