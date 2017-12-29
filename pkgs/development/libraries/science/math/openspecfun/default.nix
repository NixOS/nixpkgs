{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation {
  name = "openspecfun-0.4";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openspecfun/archive/v0.4.tar.gz";
    sha256 = "0nsa3jjmlhcqkw5ba5ypbn3n0c8b6lc22zzlxnmxkxi9shhdx65z";
  };

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ gfortran ];

  meta = {
    description = "A collection of special mathematical functions";
    homepage = https://github.com/JuliaLang/openspecfun;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.all;
  };
}
