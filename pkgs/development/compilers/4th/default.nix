{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "4th";
  version = "3.62.5";

  src = fetchurl {
    url = "https://sourceforge.net/projects/forth-4th/files/${pname}-${version}/${pname}-${version}-unix.tar.gz";
    sha256 = "sha256-+CL33Yz7CxdEpi1lPG7+kzV4rheJ7GCgiFCaOLyktPw=";
  };

  dontConfigure = true;

  makeFlags = [
    "-C sources"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preInstall = ''
    install -d ${placeholder "out"}/bin \
      ${placeholder "out"}/lib \
      ${placeholder "out"}/share/doc/${pname} \
      ${placeholder "out"}/share/man
  '';

  installFlags = [
    "BINARIES=${placeholder "out"}/bin"
    "LIBRARIES=${placeholder "out"}/lib"
    "DOCDIR=${placeholder "out"}/share/doc"
    "MANDIR=${placeholder "out"}/share/man"
  ];

  meta = with lib; {
    description = "A portable Forth compiler";
    homepage = "https://thebeez.home.xs4all.nl/4tH/index.html";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
