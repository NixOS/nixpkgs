{ lib, stdenv, fetchurl, fetchpatch
, libX11, libXext, xorgproto, libjpeg, giflib, libtiff, libpng
}:

stdenv.mkDerivation rec {
  pname = "imlib";
  version = "1.9.15";
  src = fetchurl {
    url = "https://tarballs.nixos.org/imlib-${version}.tar.gz";
    sha256 = "0ggjxyvgp4pxc0b88v40xj9daz90518ydnycw7qax011gxpr12d3";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2007-3568.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/imlib/files/imlib-1.9.15-bpp16-CVE-2007-3568.patch";
      sha256 = "0lxfibi094gki39sq1w4p0hcx25xlk0875agbhjkjngzx862wvbg";
    })

    # The following two patches fix the build with recent giflib.
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/imlib/files/imlib-1.9.15-giflib51-1.patch?id=c6d0ed89ad5653421f21cbf3b3d40fd9a1361828";
      sha256 = "0jynlhxcyjiwnz1m8j48xwz4z5csgyg03jfjc8xgpvvcyid4m65l";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/imlib/files/imlib-1.9.15-giflib51-2.patch?id=c6d0ed89ad5653421f21cbf3b3d40fd9a1361828";
      sha256 = "164x7rd992930rqllmr89p5ahfmbz37ipi8x0igd8gkvc8a4fd5x";
    })
  ];

  configureFlags = [
    "--disable-shm"
    "--x-includes=${libX11.dev}/include"
    "--x-libraries=${libX11.out}/lib"
  ];

  buildInputs = [ libjpeg libXext libX11 xorgproto libtiff giflib libpng ];

  meta = with lib; {
    description = "An image loading and rendering library for X11";
    platforms = platforms.unix;
    license = with licenses; [ gpl2Only lgpl2Only ];
  };
}
