{
  lib,
  SDL2,
  fetchFromGitHub,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yapesdl";
  version = "0.80.1";

  src = fetchFromGitHub {
    owner = "calmopyrin";
    repo = "yapesdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VCjxdVatu1h6VNMkLYL8Nknwn7ax0J2OhO1bc7dnQRA=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = [
    SDL2
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}c++" ];

  outputs = [ "out" "doc" ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 yapesdl -t ''${!outputBin}/bin/
    install -Dm755 README.SDL -t ''${!outputDoc}/share/doc/yapesdl/
    runHook postInstall
  '';

  meta = {
    homepage = "http://yape.plus4.net/";
    description = "Multiplatform Commodore 64 and 264 family emulator";
    changelog = "https://github.com/calmopyrin/yapesdl/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "yapesdl";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
