{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  gmp,
  mpfr,
  ntl,
  autoconf,
  automake,
  gettext,
  libtool,
  openblas ? null,
  blas,
  lapack,
  withBlas ? true,
  withNtl ? true,
}:

assert
  withBlas
  -> openblas != null && blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation rec {
  pname = "flint3";
  version = "3.1.2";

  src = fetchurl {
    url = "https://www.flintlib.org/flint-${version}.tar.gz";
    sha256 = "sha256-/bOkMaN0ZINKz/O9wUX0/o0PlR3VMnxMb5P0y6xcJwA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/flintlib/flint/commit/e7d005c369754243cba32bd782ea2a5fc874fde5.diff";
      hash = "sha256-IqEtYEpNVXfoTeerh/0ig+eDqUpAlGdBB3uO8ShYh3o=";
    })
    # C99 compliance (avoid using I as identifier): https://github.com/flintlib/flint/pull/2027
    (fetchpatch {
      name = "flint3-reserved-identifier.patch";
      url = "https://github.com/flintlib/flint/commit/b579cdd2d45aa1109a764f6838e9888b937e7ac5.patch";
      hash = "sha256-8GLlA9ACzzxSiYaxLv9+p0oJA5TS7289b0EyoNcsSaU=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];

  propagatedBuildInputs = [
    mpfr
  ];

  buildInputs =
    [
      gmp
    ]
    ++ lib.optionals withBlas [
      openblas
    ]
    ++ lib.optionals withNtl [
      ntl
    ];

  # We're not using autoreconfHook because flint's bootstrap
  # script calls autoreconf, among other things.
  preConfigure = ''
    # the following configure.ac fix is only needed for flint 3.1.X
    sed -i 's/if "$ac_cv_prog_cxx_g" = "yes"/if test "$ac_cv_prog_cxx_g" = "yes"/' configure.ac
    echo "Executing bootstrap.sh"
    ./bootstrap.sh
  '';

  configureFlags =
    [
      "--with-gmp=${gmp}"
      "--with-mpfr=${mpfr}"
    ]
    ++ lib.optionals withBlas [
      "--with-blas=${openblas}"
    ]
    ++ lib.optionals withNtl [
      "--with-ntl=${ntl}"
    ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Fast Library for Number Theory";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smasher164 ] ++ teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
  };
}
