{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libfpx";
  version = "1.3.1-7";

  src = fetchurl {
    url = "mirror://imagemagick/delegates/${pname}-${version}.tar.xz";
    sha256 = "1s28mwb06w6dj0zl6ashpj8m1qiyadawzl7cvbw7dmj1w39ipghh";
  };

  # Darwin gets misdetected as Windows without this
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-D__unix";

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libfpx/files/libfpx-1.3.1_p6-gcc6.patch?id=f28a947813dbc0a1fd1a8d4a712d58a64c48ca01";
      sha256 = "032y8110zgnkdhkdq3745zk53am1x34d912rai8q70k3sskyq22p";
    })
    # Pull upstream fix for -fno-common:
    #  https://github.com/ImageMagick/libfpx/pull/1
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/ImageMagick/libfpx/commit/c32b340581ba6c88c5092f374f655c7579b598a6.patch";
      sha256 = "1gbc0qb2ri1mj9r66wx0yn28fsr7zhhlyz2mwbica8wh34xijgz9";
    })
    # fix clang build: remove register keyword
    # remove on next update
    (fetchpatch {
      name = "remove-register-keyword.patch";
      url = "https://github.com/ImageMagick/libfpx/commit/5f340b0a490450b40302cc9948c7dfac60d40041.patch";
      hash = "sha256-6m9MFb1eWGK5cMvPmTu7uh3Pac65r2HPB8wJ8xc1O5o=";
    })
  ];

  meta = with lib; {
    homepage = "http://www.imagemagick.org";
    description = "Library for manipulating FlashPIX images";
    license = "Flashpix";
    platforms = platforms.all;
  };
}
