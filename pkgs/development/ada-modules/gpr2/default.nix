{
  lib,
  stdenv,
  fetchurl,
  gprbuild,
  which,
  gnat,
  gnatcoll-core,
  gnatcoll-iconv,
  gnatcoll-gmp,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "gpr2";
  version = "24.0.0";

  src = fetchurl {
    url = "https://github.com/AdaCore/gpr/releases/download/v${version}/gpr2-with-lkparser-${lib.versions.majorMinor version}.tgz";
    sha256 = "1g90689k94q3ma7q76gnjipfblgfvcq6ldwbzcf0l5hx6n8vbly8";
  };

  nativeBuildInputs = [
    which
    gnat
    gprbuild
  ];

  makeFlags = [
    "prefix=$(out)"
    "GPR2KBDIR=${gprbuild}/share/gprconfig"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    "ENABLE_SHARED=${if enableShared then "yes" else "no"}"
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
    license = with licenses; [
      asl20
      gpl3Only
    ];
    maintainers = with maintainers; [ heijligen ];
    platforms = platforms.all;
  };
}
