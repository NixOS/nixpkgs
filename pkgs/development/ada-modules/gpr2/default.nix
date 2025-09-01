{
  lib,
  stdenv,
  fetchurl,
  gprbuild,
  which,
  gnat,
  xmlada,
  gnatcoll-core,
  gnatcoll-iconv,
  gnatcoll-gmp,
  enableShared ? !stdenv.hostPlatform.isStatic,
  # kb database source, if null assume it is pregenerated
  gpr2kbdir ? null,
}:

stdenv.mkDerivation rec {
  pname = "gpr2";
  version = "25.0.0";

  src = fetchurl {
    url = "https://github.com/AdaCore/gpr/releases/download/v${version}/gpr2-with-gprconfig_kb-${lib.versions.majorMinor version}.tgz";
    sha512 = "70fe0fcf541f6d3d90a34cab1638bbc0283dcd765c000406e0cfb73bae1817b30ddfe73f3672247a97c6b6bfc41900bc96a4440ca0c660f9c2f7b9d3cc8f8dcf";
  };

  nativeBuildInputs = [
    which
    gnat
    gprbuild
  ];

  makeFlags = [
    "prefix=$(out)"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    "ENABLE_SHARED=${if enableShared then "yes" else "no"}"
    "GPR2_BUILD=release"
  ]
  ++ lib.optionals (gpr2kbdir != null) [
    "GPR2KBDIR=${gpr2kbdir}"
  ];

  configurePhase = ''
    runHook preConfigure
    make setup "''${makeFlagsArray[@]}" $makeFlags
    runHook postConfigure
  '';

  # fool make into thinking pregenerated targets are up to date
  preBuild = lib.optionalString (gpr2kbdir == null) ''
    touch .build/kb/{*.adb,*.ads,collect_kb}
  '';

  propagatedBuildInputs = [
    xmlada
    gnatcoll-gmp
    gnatcoll-core
    gnatcoll-iconv
  ];

  meta = with lib; {
    description = "Framework for analyzing the GNAT Project (GPR) files";
    homepage = "https://github.com/AdaCore/gpr";
    license = with licenses; [
      asl20
      gpl3Only
    ];
    maintainers = with maintainers; [ heijligen ];
    platforms = platforms.all;
    # TODO(@sternenseemann): investigate failure with gnat 13
    broken = lib.versionOlder gnat.version "14";
  };
}
