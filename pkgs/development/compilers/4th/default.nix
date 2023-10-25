{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "4th";
  version = "3.64.1";

  src = fetchurl {
    url = "https://sourceforge.net/projects/forth-4th/files/${pname}-${version}/${pname}-${version}-unix.tar.gz";
    hash = "sha256-+W6nTNsqrf3Dvr+NbSz3uJdrXVbBI3OHR5v/rs7en+M=";
  };

  patches = [
    # Fix install manual; report this patch to upstream
    ./001-install-manual-fixup.diff
  ];

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
    homepage = "https://thebeez.home.xs4all.nl/4tH/index.html";
    description = "A portable Forth compiler";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: set Makefile according to platform
