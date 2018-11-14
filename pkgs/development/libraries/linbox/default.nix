{ stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, givaro
, pkgconfig
, blas
, fflas-ffpack
, gmpxx
, optimize ? false # impure
, withSage ? false # sage support
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "linbox";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1wfivlwp30mzdy1697w7rzb8caajim50mc8h27k82yipn2qc5n4i";
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
  ] ++ stdenv.lib.optionals withSage [
    "--enable-sage"
  ];

  patches = stdenv.lib.optionals withSage [
    # https://trac.sagemath.org/ticket/24214#comment:39
    # Will be resolved by
    # https://github.com/linbox-team/linbox/issues/69
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/a843f48b7a4267e44895a3dfa892c89c85b85611/build/pkgs/linbox/patches/linbox_charpoly_fullCRA.patch";
      sha256 = "16nxfzfknra3k2yk3xy0k8cq9rmnmsch3dnkb03kx15h0y0jmibk";
    })
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
