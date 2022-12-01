{ config
, stdenv
, lib
, fetchFromGitHub
, cmake
, gtest
, doCheck ? true
, cudaSupport ? config.cudaSupport or false
, ncclSupport ? false
, cudaPackages
, llvmPackages
}:

assert ncclSupport -> cudaSupport;

stdenv.mkDerivation rec {
  pname = "xgboost";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-h7zcHCOxe1h7HRB6idtjf4HUBEoHC4V2pqbN9hpe00g=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    llvmPackages.openmp
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [ gtest ] ++ lib.optional cudaSupport cudaPackages.cudatoolkit
                ++ lib.optional ncclSupport cudaPackages.nccl;

  cmakeFlags = lib.optionals doCheck [ "-DGOOGLE_TEST=ON" ]
    ++ lib.optionals cudaSupport [ "-DUSE_CUDA=ON" "-DCUDA_HOST_COMPILER=${cudaPackages.cudatoolkit.cc}/bin/cc" ]
    ++ lib.optionals (cudaSupport && lib.versionAtLeast cudaPackages.cudatoolkit.version "11.4.0") [ "-DBUILD_WITH_CUDA_CUB=ON" ]
    ++ lib.optionals ncclSupport [ "-DUSE_NCCL=ON" ];

  inherit doCheck;

  # By default, cmake build will run ctests with all checks enabled
  # If we're building with cuda, we run ctest manually so that we can skip the GPU tests
  checkPhase = lib.optionalString cudaSupport ''
    ctest --force-new-ctest-process ${lib.optionalString cudaSupport "-E TestXGBoostLib"}
  '';

  installPhase = let
    libname = "libxgboost${stdenv.hostPlatform.extensions.sharedLibrary}";
  in ''
    runHook preInstall
    mkdir -p $out
    cp -r ../include $out
    install -Dm755 ../lib/${libname} $out/lib/${libname}
    install -Dm755 ../xgboost $out/bin/xgboost
    runHook postInstall
  '';

  meta = with lib; {
    description = "Scalable, Portable and Distributed Gradient Boosting (GBDT, GBRT or GBM) Library";
    homepage = "https://github.com/dmlc/xgboost";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
