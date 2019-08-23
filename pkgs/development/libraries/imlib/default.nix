{stdenv, fetchurl, fetchpatch, libX11, libXext, xorgproto, libjpeg, libungif, libtiff, libpng}:

stdenv.mkDerivation {
  name = "imlib-1.9.15";
  src = fetchurl {
    url = http://tarballs.nixos.org/imlib-1.9.15.tar.gz;
    sha256 = "0ggjxyvgp4pxc0b88v40xj9daz90518ydnycw7qax011gxpr12d3";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2007-3568.patch";
      url = https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/imlib/files/imlib-1.9.15-bpp16-CVE-2007-3568.patch;
      sha256 = "0lxfibi094gki39sq1w4p0hcx25xlk0875agbhjkjngzx862wvbg";
    })
  ];

  configureFlags = [
    "--disable-shm"
    "--x-includes=${libX11.dev}/include"
    "--x-libraries=${libX11.out}/lib"
  ];

  buildInputs = [libjpeg libXext libX11 xorgproto libtiff libungif libpng];

  meta = with stdenv.lib; {
    description = "An image loading and rendering library for X11";
    platforms = platforms.unix;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
