{
  lib,
  stdenv,
  fetchzip,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "zdbsp";
  version = "1.19";

  src = fetchzip {
    url = "https://zdoom.org/files/utils/zdbsp/zdbsp-${version}-src.zip";
    sha256 = "sha256-DTj0jMNurvwRwMbo0L4+IeNlbfIwUbqcG1LKd68C08g=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  installPhase = ''
    install -Dm755 zdbsp $out/bin/zdbsp
  '';

  meta = with lib; {
    homepage = "https://zdoom.org/wiki/ZDBSP";
    description = "ZDoom's internal node builder for DOOM maps";
    mainProgram = "zdbsp";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      lassulus
      siraben
    ];
    platforms = platforms.unix;
  };
}
