{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  perl,
  nixosTests,
  withDebug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyproxy";
  version = "1.11.3";

  src = fetchFromGitHub {
    hash = "sha256-In/ZG50i2jKl0x7yfSs3KHlBdm8NdXtspMJPiv4BW6g=";
    rev = finalAttrs.version;
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

  patches = [
    # Fix case-sensitive matching of "chunked" (CVE-2026-31842)
    (fetchpatch {
      name = "fix-chunked-case-sensitivity.patch";
      url = "https://github.com/tinyproxy/tinyproxy/commit/879bf844abffa0bf5fae6aff0c73179024dd9f98.patch";
      hash = "sha256-kU9Vqf2YtnKNJU4eQlau/ijtXkGPS/n+YSeficfu7JM=";
    })
    # Remove when updating to the first upstream release containing these fixes.
    (fetchpatch {
      name = "CVE-2026-54387.patch";
      url = "https://github.com/tinyproxy/tinyproxy/commit/623bfc093df009296f0b85d40bc677ef9d5c09bb.patch";
      hash = "sha256-BSnK3XkBFW43cnD937RKr7FJzQT90BxJkILXz/QPZo8=";
    })
    (fetchpatch {
      name = "CVE-2026-54388.patch";
      url = "https://github.com/tinyproxy/tinyproxy/commit/364cdb67e0ea00a8e4a7037e2693e0711e816adb.patch";
      hash = "sha256-+Z/Rj/zNldfOPVzWUlFHa37LEfSh/PtXOaN8z++ONJQ=";
    })
    (fetchpatch {
      name = "CVE-2026-55202.patch";
      url = "https://github.com/tinyproxy/tinyproxy/commit/09312a185ae25cc486b4ff5987638a7917a48bce.patch";
      hash = "sha256-kwYk5E95KQK42ebLV0nHB706VynDnjHB/5eENKO7Eaw=";
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
})
