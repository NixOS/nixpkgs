{ config, stdenv, lib, fetchgit, cmake
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, ncclSupport ? false, nccl
, llvmPackages
}:

assert ncclSupport -> cudaSupport;

stdenv.mkDerivation rec {
  name = "xgboost-${version}";
  version = "0.72";

  # needs submodules
  src = fetchgit {
    url = "https://github.com/dmlc/xgboost";
    rev = "refs/tags/v${version}";
    sha256 = "1d4kw2jm7d12g8qwi7p9r3429y7sjks9xp9yhvfpx5jh7qakkxj6";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  buildInputs = lib.optional cudaSupport cudatoolkit
                ++ lib.optional ncclSupport nccl;

  cmakeFlags = lib.optionals cudaSupport [ "-DUSE_CUDA=ON" "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc" ]
               ++ lib.optional ncclSupport "-DUSE_NCCL=ON";

  installPhase = let
    libname = if stdenv.isDarwin then "libxgboost.dylib" else "libxgboost.so";
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
