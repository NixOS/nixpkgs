{ lib
, config
, stdenv
, fetchFromGitHub
, cmake
, libiconv
, llvmPackages
, ninja
, openssl
, python3Packages
, ragel
, yasm
, zlib
, R
, rPackages
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
, pythonSupport ? false
, rLibrary ? false
}:

assert rLibrary -> !pythonSupport;
assert pythonSupport -> !rLibrary;

stdenv.mkDerivation (finalAttrs: rec {
  pnameBase = "catboost";
  pname = lib.optionalString rLibrary "r-" + finalAttrs.pnameBase;
  # The R package build results in a special catboost.so file
  # that contains a subset of the .so file use for the CLI
  # and python version. Catboost is not available from CRAN, so
  # the rLibrary option follows the same steps as r-modules.
  # Build with:
  # nix-build -E "with (import $NIXPKGS{}); \
  #   let \
  #     cboost = catboost.override{ rLibrary = true; }; \
  #   in \
  #   rWrapper.override{ packages = [ cboost ]; }"
  # An overlay would also work fine.
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = "catboost";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-A1zCIqPOW21dHKBQHRtS+/sstZ2o6F8k71lmJFGn0+g=";
  };

  patches = [
    ./remove-conan.patch
  ];

  postPatch = ''
    substituteInPlace cmake/common.cmake \
      --replace  "\''${RAGEL_BIN}" "${ragel}/bin/ragel" \
      --replace "\''${YASM_BIN}" "${yasm}/bin/yasm"

    # catboost caps the number of threads to ensure deterministic
    # results in tests, but the limit causes the library to fail
    # on larger machines. Raising the limit seems to have no
    # adverse effect on smaller machines which are already well
    # under the limit. See some discussion here:
    # https://github.com/catboost/catboost/issues/120
    substituteInPlace catboost/private/libs/options/restrictions.h \
      --replace "CB_THREAD_LIMIT = 128" "CB_THREAD_LIMIT = 300"

    shopt -s globstar
    for cmakelists in **/CMakeLists.*; do
      sed -i "s/OpenSSL::OpenSSL/OpenSSL::SSL/g" $cmakelists
      ${lib.optionalString (lib.versionOlder cudaPackages.cudaVersion "11.8") ''
        sed -i 's/-gencode=arch=compute_89,code=sm_89//g' $cmakelists
        sed -i 's/-gencode=arch=compute_90,code=sm_90//g' $cmakelists
      ''}
    done
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    llvmPackages.bintools
    ninja
    (python3Packages.python.withPackages (ps: with ps; [ six ]))
    ragel
    yasm
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_nvcc
    autoAddOpenGLRunpathHook
  ]) ++ lib.optionals rLibrary [ R rPackages.devtools rPackages.withr ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart
    cuda_cccl
    libcublas
  ]);

  propagatedBuildInputs = lib.optionals rLibrary [
    rPackages.jsonlite
  ];

  env = {
    CUDAHOSTCXX = lib.optionalString cudaSupport "${stdenv.cc}/bin/cc";
    NIX_CFLAGS_LINK = lib.optionalString stdenv.isLinux "-fuse-ld=lld";
    NIX_LDFLAGS = "-lc -lm";
  };

  cmakeFlags = [
    "-DCMAKE_BINARY_DIR=$out"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=on"
    "-DCATBOOST_COMPONENTS=app;libs${lib.optionalString pythonSupport ";python-package"}${lib.optionalString rLibrary ";R-package"}"
  ] ++ lib.optionals cudaSupport [
    "-DHAVE_CUDA=yes"
  ];

  preConfigure = lib.optionals rLibrary ''
    export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
  '';

  postConfigure = lib.optionals rLibrary ''
    # catboost's configure step deletes the contents of the R-package directory
    # and this step replaces it from src so it can be build for rLibrary
    cp -r $src/catboost/R-package/* catboost/R-package
  '';

  installPhase = ''
    runHook preInstall
    mkdir $dev
    cp -r catboost $dev
  '' + lib.optionalString (!rLibrary) ''
    install -Dm555 catboost/app/catboost -t $out/bin
    install -Dm444 catboost/libs/model_interface/static/lib/libmodel_interface-static-lib.a -t $out/lib
    install -Dm444 catboost/libs/model_interface/libcatboostmodel${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
    install -Dm444 catboost/libs/train_interface/libcatboost${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
  '' + lib.optionalString rLibrary ''
    mkdir $out
    mkdir $out/library
    export R_LIBS_SITE="$out/library:$R_LIBS_SITE''${R_LIBS_SITE:+:}"
    ${R}/bin/R CMD INSTALL -l $out/library catboost/R-package
  '' + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString rLibrary ''
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  meta = with lib; {
    description = "High-performance library for gradient boosting on decision trees";
    longDescription = ''
      A fast, scalable, high performance Gradient Boosting on Decision Trees
      library, used for ranking, classification, regression and other machine
      learning tasks for Python, R, Java, C++. Supports computation on CPU and GPU.
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    homepage = "https://catboost.ai";
    maintainers = with maintainers; [ PlushBeaver natsukium ];
    mainProgram = "catboost";
  };
})
