{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
  nixosTests,
  withDebug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyproxy";
  version = "1.11.2";

  src = fetchFromGitHub {
    hash = "sha256-bpr/O723FmW2gb+85aJrwW5/U7R2HwbePTx15i3rpsE=";
    rev = finalAttrs.version;
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

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
