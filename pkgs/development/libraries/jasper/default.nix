{ stdenv, fetchurl, fetchpatch, unzip, libjpeg, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "jasper-1.900.1";

  src = fetchurl {
    url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.zip";
    sha256 = "154l7zk7yh3v8l2l6zm5s2alvd2fzkp6c9i18iajfbna5af5m43b";
  };

  patches = [
    ./jasper-CVE-2016-1867.diff
    ./jasper-CVE-2014-8137-variant2.diff
    ./jasper-CVE-2014-8137-noabort.diff
    ./jasper-CVE-2014-8138.diff
    ./jasper-CVE-2014-8157.diff
    ./jasper-CVE-2014-8158.diff
    ./jasper-CVE-2014-9029.diff
    (fetchpatch { # CVE-2016-2116
      url = "https://github.com/mdadams/jasper/commit/142245b9bbb33274a7c620aa7a8f85bc00b2d68e.patch";
      sha256 = "06dkplqfb3swmdfqb9i2m6r13q0ivn538xfvinxz0agandxyc9yr";
    })
    (fetchpatch { # CVE-2016-1577
      url = "https://github.com/mdadams/jasper/commit/74ea22a7a4fe186e0a0124df25e19739b77c4a29.patch";
      sha256 = "1xgvhfhv8r77z0a07ick2w3217mypnkaqjwzxbk1g1ym8lsy5r13";
    })
    (fetchpatch { # CVE-2015-5221
      url = "https://github.com/mdadams/jasper/commit/df5d2867e8004e51e18b89865bc4aa69229227b3.patch";
      sha256 = "0qsiymm59dkj843dbi43ijqdyy3rrzf193ndm9ynj3cfhqghi10l";
    })
    (fetchpatch { # CVE-2008-3522
      url = "https://github.com/mdadams/jasper/commit/d678ccd27b8a062e3bfd4c80d8ce2676a8166a27.patch";
      sha256 = "0dapf8h4s3zijbgd8vmap3blpnc78h7jqm5ydv8j0krrs5dv5672";
    })
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
  nativeBuildInputs = [ unzip autoreconfHook ];
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
