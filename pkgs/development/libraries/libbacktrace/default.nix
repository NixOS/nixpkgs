{ stdenv
, lib
, fetchFromGitHub
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
, unstableGitUpdater
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "libbacktrace";
  version = "unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "14818b7783eeb9a56c3f0fca78cefd3143f8c5f6";
    sha256 = "DQZQsqzeQ/0v87bfqs6sXqS2M5Tunc1OydTWRSB3PCw=";
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
