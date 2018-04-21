{stdenv, fetchFromGitHub, autoreconfHook, givaro, pkgconfig, openblas, liblapack}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fflas-ffpack";
  version = "2.3.2";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1cqhassj2dny3gx0iywvmnpq8ca0d6m82xl5rz4mb8gaxr2kwddl";
  };
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ givaro (liblapack.override {shared = true;}) openblas];
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
