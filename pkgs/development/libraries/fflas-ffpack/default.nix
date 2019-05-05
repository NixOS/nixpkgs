{ stdenv, fetchFromGitHub, autoreconfHook, givaro, pkgconfig, blas
, fetchpatch
, gmpxx
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

  patches = [
    # https://github.com/linbox-team/fflas-ffpack/issues/146
    (fetchpatch {
      name = "fix-flaky-test-fgemm-check.patch";
      url = "https://github.com/linbox-team/fflas-ffpack/commit/d8cd67d91a9535417a5cb193cf1540ad6758a3db.patch";
      sha256 = "1gnfc616fvnlr0smvz6lb2d445vn8fgv6vqcr6pwm3dj4wa6v3b3";
    })
  ];

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
  ] ++ stdenv.lib.optionals stdenv.isx86_64 {
    # disable SIMD instructions (which are enabled *when available* by default)
    "default"        = [ "--disable-sse3" "--disable-ssse3" "--disable-sse41" "--disable-sse42" "--disable-avx" "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    "westmere"       = [                                                                        "--disable-avx" "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    "sandybridge"    = [                                                                                        "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    "ivybridge"      = [                                                                                        "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    "haswell"        = [                                                                                                                         "--disable-fma4" ];
    "broadwell"      = [                                                                                                                         "--disable-fma4" ];
    "skylake"        = [                                                                                                                         "--disable-fma4" ];
    "skylake-avx512" = [                                                                                                                         "--disable-fma4" ];
  }.${stdenv.hostPlatform.platform.gcc.arch or "default"};

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
