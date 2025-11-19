{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gnum4,
  gmp,
  ecm,
  enableCuda ? false,
  enableSse41 ? false,
  enableAvx2 ? false,
  enableBmi2 ? false,
  enableSkylakex ? false,
  enableIcelake ? false,
  disableZlib ? false,
  vbits ? null,
  cudaPackages ? null,
  zlib,
}:

assert enableCuda -> cudaPackages != null;
assert
  vbits != null
  -> lib.elem vbits [
    64
    128
    256
  ];

stdenv.mkDerivation {
  pname = "yafu";
  version = "3.0-unstable-2024-11-04";

  src = fetchFromGitHub {
    owner = "bbuhrow";
    repo = "yafu";
    rev = "ada8bf3b43a684d6217891f593fd7c6f5e61982d";
    hash = "sha256-w6BhDNQu5GxOwFRqHXBEsXN1UwaMfeAVvLeRfy4QndE=";
  };

  nativeBuildInputs = [
    makeWrapper
    gnum4
  ];

  buildInputs = [

    (gmp.override { withStatic = true; })
  ]
  ++ lib.optional enableCuda cudaPackages.cuda_cudart
  ++ lib.optional (!disableZlib) zlib;

  # YAFU's build system doesn't have a configure phase
  dontConfigure = true;

  makeFlags =
    let
      hp = stdenv.hostPlatform;
    in
    lib.optionals enableCuda [ "CUDA=1" ]
    ++ lib.optionals disableZlib [ "NO_ZLIB=1" ]
    ++ lib.optionals (vbits != null) [ "VBITS=${toString vbits}" ]
    ++ lib.optionals (hp.sse4_1Support or enableSse41) [ "USE_SSE41=1" ]
    ++ lib.optionals (hp.avx2Support or enableAvx2) [ "USE_AVX2=1" ]
    ++ lib.optionals (hp.avx2Support or enableBmi2) [ "USE_BMI2=1" ]
    ++ lib.optionals (hp.avx512Support or enableSkylakex) [ "SKYLAKEX=1" ]
    ++ lib.optionals ((lib.hasPrefix "icelake" (hp.gcc.arch or "")) || enableIcelake) [ "ICELAKE=1" ];

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    "-Wno-error=int-conversion"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=implicit-function-declaration"
  ];

  postPatch = ''
    sed -i 's|^CFLAGS=.*-DBITS_PER_GMP_ULONG=32.*|CFLAGS=-m64 -g -Ofast -march=native -I. -I${
      gmp.override { withStatic = true; }
    }/include -DULL_NO_UL -DBITS_PER_GMP_ULONG=64|' factor/lasieve5_64/Makefile

    sed -i '/-I.*mingw.*include/d' factor/lasieve5_64/Makefile

    substituteInPlace factor/lasieve5_64/Makefile --replace-fail '../../../gmp-install/mingw' '${
      gmp.override { withStatic = true; }
    }'

    substituteInPlace top/cmdParser/cmdOptions.c --replace-fail 'printf("warning: could not open %s, no options parsed\n", filename);' 'if (strcmp(filename, "yafu.ini") != 0) printf("warning: could not open %s, no options parsed\n", filename);'

    substituteInPlace top/driver.c --replace-fail 'fopen("docfile.txt","r")' "fopen(\"$out/share/yafu/docfile.txt\",\"r\")"
    substituteInPlace top/driver.c --replace-fail "int ini_success;" "int ini_success; int loaded_global = 0;"
    substituteInPlace top/driver.c --replace-fail 'ini_success = readINI("yafu.ini", options);' "ini_success = readINI(\"yafu.ini\", options); if (!ini_success) { ini_success = readINI(\"$out/share/yafu/yafu.ini\", options); if (ini_success) loaded_global = 1; }"
    substituteInPlace top/driver.c --replace-fail 'yafu_obj.CWD);' "(loaded_global ? \"$out/share/yafu/yafu.ini\" : yafu_obj.CWD));"

    sed -i "s|-I\.\./gmp-install.*include|-I${
      gmp.override { withStatic = true; }
    }/include|g" Makefile.gcc
    sed -i "s|-L\.\./gmp-install.*lib|-L${gmp.override { withStatic = true; }}/lib|g" Makefile.gcc

    sed -i "s|-I\.\./ecm-install.*include/|-I${ecm}/include|g" Makefile.gcc
    sed -i "s|-L\.\./ecm-install.*lib/|-L${ecm}/lib|g" Makefile.gcc
  '';

  preBuild = ''
    pushd factor/lasieve5_64
    ln -s athlon64 asm
    popd
  '';

  buildPhase = ''
    runHook preBuild
    pushd factor/lasieve5_64
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fcommon -mavx2" make -f Makefile alle # -mavx2 required for now
    popd
    make -f Makefile.gcc yafu $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 yafu -t $out/bin
    pushd factor/lasieve5_64/
    install -Dm755 gnfs-lasieve4I1[1-6]e -t $out/libexec/yafu
    popd

    local dataDir="$out/share/$pname"
    mkdir -p $dataDir
    install -Dm644 docfile.txt -t $dataDir
    install -Dm644 yafu.ini -t $dataDir

    sed -i "s|ecm_path=../ecm-install/bin/ecm|ecm_path=${ecm}/bin/ecm|" $dataDir/yafu.ini
    sed -i "s|ggnfs_dir=factor/lasieve5_64/bin/avx512/|ggnfs_dir=$out/libexec/yafu/|" $dataDir/yafu.ini
  '';

  meta = {
    description = "Automated integer factorization tool";
    longDescription = ''
      YAFU (Yet Another Factorization Utility) is a multi-purpose integer
      factorization tool that uses several factoring algorithms including
      SIQS, ECM, and NFS. It can factor integers of varying sizes using
      different strategies optimized for the size of the number.
    '';
    homepage = "https://github.com/bbuhrow/yafu";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "yafu";
  };
}
