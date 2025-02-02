{
  lib,
  stdenv,
  fetchurl,
  cmake,
  taglib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "taglib-extras";
  version = "1.0.1";
  src = fetchurl {
    url = "https://ftp.rz.uni-wuerzburg.de/pub/unix/kde/taglib-extras/${version}/src/${pname}-${version}.tar.gz";
    sha256 = "0cln49ws9svvvals5fzxjxlzqm0fzjfymn7yfp4jfcjz655nnm7y";
  };
  buildInputs = [ taglib ];
  nativeBuildInputs = [
    cmake
    zlib
  ];

  # Workaround for upstream bug https://bugs.kde.org/show_bug.cgi?id=357181
  preConfigure = ''
    sed -i -e 's/STRLESS/VERSION_LESS/g' cmake/modules/FindTaglib.cmake
  '';

  meta = with lib; {
    description = "Additional taglib plugins";
    mainProgram = "taglib-extras-config";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
