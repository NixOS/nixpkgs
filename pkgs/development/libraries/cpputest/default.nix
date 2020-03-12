{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "3.8";
  pname = "cpputest";

  src = fetchurl {
    url = "https://github.com/cpputest/cpputest/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0mk48xd3klyqi7wf3f4wn4zqxxzmvrhhl32r25jzrixzl72wq7f8";
  };

  meta = {
    homepage = http://cpputest.github.io/;
    description = "Unit testing and mocking framework for C/C++";
    platforms = stdenv.lib.platforms.linux ;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.juliendehos ];
  };
}
