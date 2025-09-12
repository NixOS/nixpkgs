{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  protobufc,
  libconfig,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umurmur";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pJRGyfG5y5wdB+zoWiJ1+2O1L3TThC6IairVDlE76tA=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    protobufc
    libconfig
  ];

  configureFlags = [
    "--with-ssl=openssl"
    "--enable-shmapi"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) umurmur;
    };
  };

  meta = {
    description = "Minimalistic Murmur (Mumble server)";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/umurmur/umurmur";
    platforms = lib.platforms.all;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "umurmurd";
  };
})
