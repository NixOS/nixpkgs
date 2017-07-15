{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xgboost-${version}";
  version = "0.60";

  # needs submodules
  src = fetchFromGitHub {
    owner = "dmlc";
    repo = "xgboost";
    rev = "refs/tags/v${version}";
    sha256 = "16frxnwnn1kmfr013c838vzx6g2fqqs1rwvf5bcjd796369kkydm";
  };

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out
    cp -r include $out
    install -Dm755 lib/libxgboost.so $out/lib/libxgboost.so
    install -Dm755 xgboost $out/bin/xgboost
  '';

  meta = with stdenv.lib; {
    description = "Scalable, Portable and Distributed Gradient Boosting (GBDT, GBRT or GBM) Library";
    homepage = "https://github.com/dmlc/xgboost";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
