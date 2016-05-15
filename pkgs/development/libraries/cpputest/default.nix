{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "3.7.2";
  name = "cpputest-${version}";

  src = fetchurl {
    url = "https://github.com/cpputest/cpputest/releases/download/${version}/${name}.tar.gz";
    sha256 = "0lwn226d8mrppdyzcvr08vsnnp6h0mpy5kz5a475ish87az00pcc";
  };

  meta = {
    homepage = "http://cpputest.github.io/";
    description = "Unit testing and mocking framework for C/C++";
    platforms = stdenv.lib.platforms.linux ;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.juliendehos ];
  };
}
