{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, giflib, libjpeg, libpng, libX11, zlib
, static ? stdenv.hostPlatform.isStatic
, withX ? !stdenv.isDarwin }:

stdenv.mkDerivation {
  pname = "libAfterImage";
  version = "1.20";

  src = fetchurl {
    name = "libAfterImage-1.20.tar.bz2";
    urls = [
      "https://sourceforge.net/projects/afterstep/files/libAfterImage/1.20/libAfterImage-1.20.tar.bz2/download"
      "ftp://ftp.afterstep.org/stable/libAfterImage/libAfterImage-1.20.tar.bz2"
    ];
    sha256 = "0n74rxidwig3yhr6fzxsk7y19n1nq1f296lzrvgj5pfiyi9k48vf";
  };

  patches = [
    # add back --with-gif option
    (fetchpatch {
      name = "libafterimage-gif.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libafterimage/files/libafterimage-gif.patch?id=4aa4fca00611b0b3a4007870da43cc5fd63f76c4";
      sha256 = "16pa94wlqpd7h6mzs4f0qm794yk1xczrwsgf93kdd3g0zbjq3rnr";
    })

    # fix build with newer giflib
    (fetchpatch {
      name = "libafterimage-giflib5-v2.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libafterimage/files/libafterimage-giflib5-v2.patch?id=4aa4fca00611b0b3a4007870da43cc5fd63f76c4";
      sha256 = "0qwydqy9bm73cg5n3vm97aj4jfi70p7fxqmfbi54vi78z593brln";
      stripLen = 1;
    })

    # fix build with newer libpng
    (fetchpatch {
      name = "libafterimage-libpng15.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libafterimage/files/libafterimage-libpng15.patch?id=4aa4fca00611b0b3a4007870da43cc5fd63f76c4";
      sha256 = "1qyvf7786hayasfnnilfbri3p99cfz5wjpbli3gdqj2cvk6mpydv";
    })

    # fix an ldconfig problem
    (fetchpatch {
      name = "libafterimage-makefile.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libafterimage/files/libafterimage-makefile.in.patch?id=4aa4fca00611b0b3a4007870da43cc5fd63f76c4";
      sha256 = "1n6fniz6dldms615046yhc4mlg9gb53y4yfia8wfz6szgq5zicj4";
    })
  ];
  patchFlags = [ "-p0" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ giflib libjpeg libpng zlib ] ++ lib.optional withX libX11;

  preConfigure = ''
    rm -rf {libjpeg,libpng,libungif,zlib}/
    substituteInPlace Makefile.in \
      --replace "include .depend" ""
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.in \
      --replace "-soname," "-install_name,$out/lib/"
  '';

  configureFlags = [
    "--with-gif"
    "--disable-mmx-optimization"
    "--${if static then "enable" else "disable"}-staticlibs"
    "--${if !static then "enable" else "disable"}-sharedlibs"
  ] ++ lib.optional withX "--with-x";

  meta = with lib; {
    homepage = "http://www.afterstep.org/afterimage/";
    description = "A generic image manipulation library";
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
    license = licenses.lgpl21;
  };
}
