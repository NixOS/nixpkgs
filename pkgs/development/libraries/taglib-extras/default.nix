{stdenv, fetchurl, cmake, taglib}:

stdenv.mkDerivation rec {
  name = "taglib-extras-1.0.1";
  src = fetchurl {
    url = "http://ftp.rz.uni-wuerzburg.de/pub/unix/kde/taglib-extras/1.0.1/src/${name}.tar.gz";
    sha256 = "0cln49ws9svvvals5fzxjxlzqm0fzjfymn7yfp4jfcjz655nnm7y";
  };
  buildInputs = [ taglib ];
  nativeBuildInputs = [ cmake ];

  # Workaround for upstream bug https://bugs.kde.org/show_bug.cgi?id=357181
  preConfigure = ''
    sed -i -e 's/STRLESS/VERSION_LESS/g' cmake/modules/FindTaglib.cmake
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
