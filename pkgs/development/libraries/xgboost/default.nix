{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "xgboost-${version}";
  version = "2016-05-14";

  # needs submodules
  src = fetchgit {
    url = "https://github.com/dmlc/xgboost";
    rev = "9c26566eb09733423f821f139938ff4105c3775d";
    sha256 = "0nmhgl70mnc2igkfppdw2in66zdczzsqxrlsb4bknrglpp3axnm1";
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
