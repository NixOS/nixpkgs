{ stdenv, lib, fetchgit, cmake
, avxSupport ? false
, cudaSupport ? false, cudatoolkit
, ncclSupport ? false, nccl
}:

assert ncclSupport -> cudaSupport;

stdenv.mkDerivation rec {
  name = "xgboost-${version}";
  version = "0.7";

  # needs submodules
  src = fetchgit {
    url = "https://github.com/dmlc/xgboost";
    rev = "refs/tags/v${version}";
    sha256 = "1wxh020l4q037hc5z7vgxflb70l41a97anl8g6y4wxb74l5zv61l";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional cudaSupport cudatoolkit
                ++ lib.optional ncclSupport nccl;

  cmakeFlags = lib.optionals cudaSupport [ "-DUSE_CUDA=ON" "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc" ]
               ++ lib.optional ncclSupport "-DUSE_NCCL=ON";

  installPhase = ''
    mkdir -p $out
    cp -r ../include $out
    install -Dm755 ../lib/libxgboost.so $out/lib/libxgboost.so
    install -Dm755 ../xgboost $out/bin/xgboost
  '';

  meta = with stdenv.lib; {
    description = "Scalable, Portable and Distributed Gradient Boosting (GBDT, GBRT or GBM) Library";
    homepage = https://github.com/dmlc/xgboost;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
