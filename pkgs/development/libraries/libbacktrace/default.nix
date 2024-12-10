{
  stdenv,
  lib,
  fetchFromGitHub,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
  unstableGitUpdater,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "libbacktrace";
  version = "0-unstable-2024-03-02";

  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "28824f2cc9069e3fdc39d3702acdf753e35c41b4";
    sha256 = "1k1O1GT22hZAWPF8NYP0y4qe+e3pGfzT9Mz2TH+H/v4=";
  };

  patches = [
    # Fix tests with shared library.
    # https://github.com/ianlancetaylor/libbacktrace/pull/99
    ./0001-libbacktrace-avoid-libtool-wrapping-tests.patch

    # Support multiple debug dirs.
    # https://github.com/ianlancetaylor/libbacktrace/pull/100
    ./0002-libbacktrace-Allow-configuring-debug-dir.patch
    ./0003-libbacktrace-Support-multiple-build-id-directories.patch

    # Support NIX_DEBUG_INFO_DIRS environment variable.
    ./0004-libbacktrace-Support-NIX_DEBUG_INFO_DIRS-environment.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
  ];

  doCheck = stdenv.isLinux && !stdenv.hostPlatform.isMusl;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "A C library that may be linked into a C/C++ program to produce symbolic backtraces";
    homepage = "https://github.com/ianlancetaylor/libbacktrace";
    maintainers = with maintainers; [ twey ];
    license = with licenses; [ bsd3 ];
  };
}
