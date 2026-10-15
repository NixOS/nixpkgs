{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libseccomp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unstick";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kwohlfahrt";
    repo = "unstick";
    rev = "effee9aa242ca12dc94cc6e96bc073f4cc9e8657";
    hash = "sha256-G1pLzmza7QLXKRp4fKnC6yWJGek/uYVIvcTRX6sciiI=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ libseccomp ];

  meta = {
    homepage = "https://github.com/kwohlfahrt/unstick";
    description = "Silently eats chmod commands forbidden by Nix";
    mainProgram = "unstick";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kwohlfahrt ];
  };
})
