{ config, stdenv, lib, fetchgit, cmake
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, ncclSupport ? false, nccl
, llvmPackages
}:

assert ncclSupport -> cudaSupport;

stdenv.mkDerivation rec {
  pname = "xgboost";
  version = "0.90";

  # needs submodules
  src = fetchgit {
    url = "https://github.com/dmlc/xgboost";
    rev = "refs/tags/v${version}";
    sha256 = "1zs15k9crkiq7bnr4gqq53mkn3w8z9dq4nwlavmfcr5xr5gw2pw4";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  buildInputs = lib.optional cudaSupport cudatoolkit
                ++ lib.optional ncclSupport nccl;

  cmakeFlags = lib.optionals cudaSupport [ "-DUSE_CUDA=ON" "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc" ]
               ++ lib.optional ncclSupport "-DUSE_NCCL=ON";

  installPhase = let
    libname = "libxgboost${stdenv.hostPlatform.extensions.sharedLibrary}";
  in ''
    mkdir -p $out
    cp -r ../include $out
    install -Dm755 ../lib/${libname} $out/lib/${libname}
    install -Dm755 ../xgboost $out/bin/xgboost
  '';

  meta = with stdenv.lib; {
    description = "Scalable, Portable and Distributed Gradient Boosting (GBDT, GBRT or GBM) Library";
    homepage = https://github.com/dmlc/xgboost;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
