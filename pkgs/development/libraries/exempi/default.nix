{ stdenv, fetchurl, fetchpatch, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  name = "exempi-2.4.5";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${name}.tar.bz2";
    sha256 = "07i29xmg8bqriviaf4vi1mwha4lrw85kfla29cfym14fp3z8aqa0";
  };

  patches = [
    # CVE-2018-12648
    # https://gitlab.freedesktop.org/libopenraw/exempi/issues/9
    # remove with exempi > 2.4.5
    (fetchpatch {
      name = "CVE-2018-12648.patch";
      url = https://gitlab.freedesktop.org/libopenraw/exempi/commit/8ed2f034705fd2d032c81383eee8208fd4eee0ac.patch;
      sha256 = "1nh8irk5p26868875wq5n8g92xp4crfb8fdd8gyna76ldyzqqx9q";
    })
  ];

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  buildInputs = [ expat zlib boost ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.CoreServices ];

  doCheck = stdenv.isLinux;

  meta = with stdenv.lib; {
    homepage = https://libopenraw.freedesktop.org/wiki/Exempi/;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
