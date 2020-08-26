{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "4.0";
  pname = "cpputest";

  src = fetchurl {
    url = "https://github.com/cpputest/cpputest/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1xslavlb1974y5xvs8n1j9zkk05dlw8imy4saasrjlmibl895ii1";
  };

  meta = {
    homepage = "http://cpputest.github.io/";
    description = "Unit testing and mocking framework for C/C++";
    platforms = stdenv.lib.platforms.linux ;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.juliendehos ];
  };
}
