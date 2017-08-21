{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "xgboost-${version}";
  version = "0.60";

  # needs submodules
  src = fetchgit {
    url = "https://github.com/dmlc/xgboost";
    rev = "refs/tags/v${version}";
    sha256 = "0536vfl59n9vlagl1cpdl06c9y19dscwhwdzvi27zk5nc5qb6rdq";
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
    homepage = https://github.com/dmlc/xgboost;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
