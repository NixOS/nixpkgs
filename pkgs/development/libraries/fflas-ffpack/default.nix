{ stdenv, fetchFromGitHub, autoreconfHook, givaro, pkgconfig, blas
, gmpxx
, optimize ? false # impure
}:
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

  checkInputs = [
    gmpxx
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ] ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [ givaro blas ];

  configureFlags = [
    "--with-blas-libs=-l${blas.linkName}"
    "--with-lapack-libs=-l${blas.linkName}"
  ] ++ stdenv.lib.optionals (!optimize) [
    # disable SIMD instructions (which are enabled *when available* by default)
    "--disable-sse"
    "--disable-sse2"
    "--disable-sse3"
    "--disable-ssse3"
    "--disable-sse41"
    "--disable-sse42"
    "--disable-avx"
    "--disable-avx2"
    "--disable-fma"
    "--disable-fma4"
  ];

  doCheck = true;

  meta = {
    inherit version;
    description = ''Finite Field Linear Algebra Subroutines'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = https://linbox-team.github.io/fflas-ffpack/;
  };
}
