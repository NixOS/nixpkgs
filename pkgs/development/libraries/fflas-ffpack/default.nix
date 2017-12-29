{stdenv, fetchFromGitHub, autoreconfHook, givaro, pkgconfig, openblas, liblapack}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fflas-ffpack";
  version = "2.2.2";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0k1f4pb7azrm6ajncvg7vni7ixfmn6fssd5ld4xddbi6jqbsf9rd";
  };
  buildInputs = [autoreconfHook givaro (liblapack.override {shared = true;}) openblas];
  nativeBuildInputs = [pkgconfig];
  configureFlags = "--with-blas-libs=-lopenblas --with-lapack-libs=-llapack";
  meta = {
    inherit version;
    description = ''Finite Field Linear Algebra Subroutines'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://linbox-team.github.io/fflas-ffpack/;
  };
}
