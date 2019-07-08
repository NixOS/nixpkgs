{ stdenv
, fetchFromGitHub
, autoreconfHook
, givaro
, pkgconfig
, blas
, fflas-ffpack
, gmpxx
, withSage ? false # sage support
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "linbox";
  version = "1.6.3";


  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "10j6dspbsq7d2l4q3y0c1l1xwmaqqba2fxg59q5bhgk9h5d7q571";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    givaro
    blas
    gmpxx
    fflas-ffpack
  ];

  configureFlags = [
    "--with-blas-libs=-l${blas.linkName}"
    "--disable-optimization"
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
  }.${stdenv.hostPlatform.platform.gcc.arch or "default"}
  ++ stdenv.lib.optionals withSage [
    "--enable-sage"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    inherit version;
    description = "C++ library for exact, high-performance linear algebra";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.timokau];
    platforms = stdenv.lib.platforms.unix;
    homepage = http://linalg.org/;
  };
}
