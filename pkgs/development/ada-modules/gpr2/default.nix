{
  lib,
  stdenv,
  fetchFromGitHub,
  gprbuild,
  which,
  gnat,
  xmlada,
  gnatcoll-core,
  gnatcoll-iconv,
  gnatcoll-gmp,
  fetchpatch2,
  enableShared ? !stdenv.hostPlatform.isStatic,
  # kb database source, if null assume it is pregenerated
  gpr2kbdir ? "${gprbuild}/share/gprconfig",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpr2";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gpr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HoD0TuhOinPGYB7gnLtJ0Zonz4RK4HA3IoOFe5NxfUE=";
  };

  nativeBuildInputs = [
    which
    gnat
    gprbuild
  ];

  makeFlags = [
    "prefix=$(out)"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    "ENABLE_SHARED=${lib.boolToYesNo enableShared}"
    "GPR2_BUILD=release"
  ]
  ++ lib.optionals (gpr2kbdir != null) [
    "GPR2KBDIR=${gpr2kbdir}"
  ];

  patches = [
    # gpr2-log.ads:140:09: error: completion of nonlimited type cannot be limited
    # gpr2-log.ads:140:09: error: component "Ref" of type "Reference_Type" has limited type
    (fetchpatch2 {
      url = "https://github.com/AdaCore/gpr/commit/43bb629645c3f558bbba5e3cf4b5902dddae3a6a.patch?full_index=1";
      hash = "sha256-EeqlHLoQEQdEnbre38UHxBgsfSUNksXnU3oOtBKw5Ek=";
    })
    # gpr2-tree_internal.adb:1926:18: error: actual for aliased formal "Container" has wrong accessibility in return (RM 6.4.1(6.4))
    (fetchpatch2 {
      url = "https://github.com/AdaCore/gpr/commit/12c649aa4d4c4e334b8271ac619500532aaeb21f.patch?full_index=1";
      hash = "sha256-jp8VZGgyiVeJZTpdeAnHf2VrCc58/MMYfyjiOSaMx6w=";
    })
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

  meta = {
    description = "Framework for analyzing the GNAT Project (GPR) files";
    homepage = "https://github.com/AdaCore/gpr";
    license = with lib.licenses; [
      llvm-exception
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      heijligen
      sempiternal-aurora
    ];
    platforms = lib.platforms.all;
  };
})
