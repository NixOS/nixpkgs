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
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
, pythonSupport ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catboost";
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
  ]);

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

  env = {
    CUDAHOSTCXX = lib.optionalString cudaSupport "${stdenv.cc}/bin/cc";
    NIX_CFLAGS_LINK = lib.optionalString stdenv.isLinux "-fuse-ld=lld";
    NIX_LDFLAGS = "-lc -lm";
  };

  cmakeFlags = [
    "-DCMAKE_BINARY_DIR=$out"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=on"
    "-DCATBOOST_COMPONENTS=app;libs${lib.optionalString pythonSupport ";python-package"}"
  ] ++ lib.optionals cudaSupport [
    "-DHAVE_CUDA=on"
  ];

  installPhase = ''
    runHook preInstall

    mkdir $dev
    cp -r catboost $dev
    install -Dm555 catboost/app/catboost -t $out/bin
    install -Dm444 catboost/libs/model_interface/static/lib/libmodel_interface-static-lib.a -t $out/lib
    install -Dm444 catboost/libs/model_interface/libcatboostmodel${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
    install -Dm444 catboost/libs/train_interface/libcatboost${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib

    runHook postInstall
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
