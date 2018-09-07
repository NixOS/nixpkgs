{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cctz-${version}";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cctz";
    rev = "v${version}";
    sha256 = "0liiqz1swfc019rzfaa9y5kavs2hwabs2vnwbn9jfczhyxy34y89";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  installTargets = [ "install_hdrs" "install_shared_lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/google/cctz;
    description = "C++ library for translating between absolute and civil times";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
