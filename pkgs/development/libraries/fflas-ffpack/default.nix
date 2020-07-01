{ stdenv, fetchFromGitHub, autoreconfHook, givaro, pkgconfig, blas, lapack
, gmpxx
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "fflas-ffpack";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = version;
    sha256 = "1ynbjd72qrwp0b4kpn0p5d7gddpvj8dlb5fwdxajr5pvkvi3if74";
  };

  checkInputs = [
    gmpxx
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ] ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [ givaro blas lapack ];

  configureFlags = [
    "--with-blas-libs=-lcblas"
    "--with-lapack-libs=-llapacke"
  ] ++ stdenv.lib.optionals stdenv.isx86_64 {
    # disable SIMD instructions (which are enabled *when available* by default)
    # for now we need to be careful to disable *all* relevant versions of an instruction set explicitly (https://github.com/linbox-team/fflas-ffpack/issues/284)
    default        = [ "--disable-sse3" "--disable-ssse3" "--disable-sse41" "--disable-sse42" "--disable-avx" "--disable-avx2" "--disable-avx512f" "--disable-avx512dq" "--disable-avx512vl" "--disable-fma" "--disable-fma4" ];
    westmere       = [                                                                        "--disable-avx" "--disable-avx2" "--disable-avx512f" "--disable-avx512dq" "--disable-avx512vl" "--disable-fma" "--disable-fma4" ];
    sandybridge    = [                                                                                        "--disable-avx2" "--disable-avx512f" "--disable-avx512dq" "--disable-avx512vl" "--disable-fma" "--disable-fma4" ];
    ivybridge      = [                                                                                        "--disable-avx2" "--disable-avx512f" "--disable-avx512dq" "--disable-avx512vl" "--disable-fma" "--disable-fma4" ];
    haswell        = [                                                                                                                                                                       "--disable-fma4" ];
    broadwell      = [                                                                                                                                                                       "--disable-fma4" ];
    skylake        = [                                                                                                                                                                       "--disable-fma4" ];
    skylake-avx512 = [                                                                                                                                                                       "--disable-fma4" ];
  }.${stdenv.hostPlatform.platform.gcc.arch or "default"};

  doCheck = true;

  meta = with stdenv.lib; {
    inherit version;
    description = ''Finite Field Linear Algebra Subroutines'';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = platforms.unix;
    homepage = "https://linbox-team.github.io/fflas-ffpack/";
  };
}
