{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  libiconv,
  readline,
  windows,
}:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.14";

  src = fetchurl {
    urls = [
      "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz"
      "https://www.unixodbc.org/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-TigU3j4B/DCwufdeg7taupGrA4TulRKGUEu3AgVSR3E=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isMinGW [
    # MSYS2 runs autoreconf to refresh libtool/autoconf plumbing for MinGW toolchains.
    autoreconfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isMinGW [
    # MSYS2 depends on these on MinGW; keep them conditional to avoid changing unix builds.
    libiconv
    readline
    # Provide libpthread.a / winpthreads for MinGW. unixODBC's build system uses -pthread
    # which otherwise resolves to -lpthread and fails the link.
    windows.pthreads
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMinGW ''
    # Prefer winpthreads on MinGW (MSYS2 depends on libwinpthread).
    export PTHREAD_LIBS="-lwinpthread"
    export PTHREAD_CFLAGS=""
  '';

  configureFlags = [
    "--disable-gui"
    "--sysconfdir=/etc"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # Align with MSYS2 mingw-w64-unixodbc PKGBUILD intent.
    "--enable-iconv=yes"
    "--enable-static"
    "--enable-shared"
  ];

  meta = {
    description = "ODBC driver manager";
    homepage = "https://www.unixodbc.org/";
    license = lib.licenses.lgpl2;
    # MSYS2 packages unixODBC for MinGW; enable it for nixpkgs Windows targets as well.
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
