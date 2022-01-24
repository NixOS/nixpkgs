{ config
, stdenv
, lib
, fetchFromGitHub
, cmake
, gtest
, doCheck ? true
, cudaSupport ? config.cudaSupport or false
, cudatoolkit
, ncclSupport ? false
, nccl
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

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  buildInputs = [ gtest ] ++ lib.optional cudaSupport cudatoolkit
                ++ lib.optional ncclSupport nccl;

  cmakeFlags = lib.optionals doCheck [ "-DGOOGLE_TEST=ON" ]
    ++ lib.optionals cudaSupport [ "-DUSE_CUDA=ON" "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc" ]
    ++ lib.optionals ncclSupport [ "-DUSE_NCCL=ON" ];

  inherit doCheck;

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
