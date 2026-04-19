{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  perl,
  nixosTests,
  withDebug ? false,
}:

stdenv.mkDerivation rec {
  pname = "tinyproxy";
  version = "1.11.3";

  src = fetchFromGitHub {
    hash = "sha256-In/ZG50i2jKl0x7yfSs3KHlBdm8NdXtspMJPiv4BW6g=";
    rev = version;
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

  patches = [
    # Fix case-sensitive matching of "chunked" (CVE-2026-31842)
    (fetchpatch2 {
      name = "fix-chunked-case-sensitivity.patch";
      url = "https://github.com/tinyproxy/tinyproxy/commit/879bf844abffa0bf5fae6aff0c73179024dd9f98.patch";
      hash = "sha256-Nav3nXyxdoM/tIvfyPJHEYEjAtrRrJlvkMXzsQCZan4=";
    })
  ];

  # perl is needed for man page generation.
  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  configureFlags = lib.optionals withDebug [ "--enable-debug" ]; # Enable debugging support code and methods.
  passthru.tests = { inherit (nixosTests) tinyproxy; };

  meta = {
    homepage = "https://tinyproxy.github.io/";
    description = "Light-weight HTTP/HTTPS proxy daemon for POSIX operating systems";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.carlosdagos ];
    mainProgram = "tinyproxy";
  };
}
