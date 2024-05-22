{ lib
, stdenv
, fetchzip
, gprbuild
, which
, gnat
, gnatcoll-core
, gnatcoll-iconv
, gnatcoll-gmp
}:

stdenv.mkDerivation rec {
  pname = "gpr2";
  version = "24.0.0";

  src = fetchzip {
    url = "https://github.com/AdaCore/gpr/releases/download/v24.0.0/gpr2-with-lkparser-24.0.tgz";
    hash = "sha256-BnvlVIU6iSE5wXcDwqpNyolin076qph3/GnUKPRy4Jo=";
  };

  nativeBuildInputs = [
    which
    gnat
    gprbuild
  ];

  makeFlags = [
    "prefix=$(out)"
    "GPR2KBDIR=${gprbuild}/share/gprconfig"
  ];

  propagatedBuildInputs = [
    gprbuild
    gnatcoll-gmp
    gnatcoll-core
    gnatcoll-iconv
  ];

  meta = with lib; {
    description = "The framework for analyzing the GNAT Project (GPR) files";
    homepage = "https://github.com/AdaCore/gpr";
    license = with licenses; [ asl20 gpl3Only ];
    maintainers = with maintainers; [ heijligen ];
    platforms = platforms.all;
  };
}
