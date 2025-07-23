{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  ntl,
  windows,
  autoconf,
  automake,
  gettext,
  libtool,
  openblas ? null,
  blas,
  lapack,
  withBlas ? true,
  withNtl ? !ntl.meta.broken,
}:

assert
  withBlas
  -> openblas != null && blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation rec {
  pname = "flint3";
  version = "3.3.1";

  src = fetchurl {
    url = "https://flintlib.org/download/flint-${version}.tar.gz";
    hash = "sha256-ZNcOUTB2z6lx4EELWMHaXTURKRPppWtE4saBtFnT6vs=";
  };

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
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      windows.mingw_w64_pthreads
    ];

  # We're not using autoreconfHook because flint's bootstrap
  # script calls autoreconf, among other things.
  preConfigure = ''
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ smasher164 ];
    teams = [ teams.sage ];
    platforms = platforms.all;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
  };
}
