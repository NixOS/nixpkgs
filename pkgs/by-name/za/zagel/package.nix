{
  lib,
  stdenv,
  rustPlatform,
  fetchurl,
  pkg-config,
  wayland,
  libxkbcommon,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  libxcb,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zagel";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/sharno/zagel/archive/refs/tags/v${finalAttrs.version}.tar.gz";
    hash = "sha256-xzeHw0vckTLnbZi6/tYuqmJPZ+oKFaAh2KEO5RoZAiY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
    libxkbcommon
    libX11
    libXcursor
    libXi
    libXinerama
    libXrandr
    libxcb
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  meta = {
    description = "Desktop REST workbench with .http/.env collections and persisted state.";
    homepage = "https://github.com/sharno/zagel";
    changelog = "https://github.com/sharno/zagel/releases/tag/v${finalAttrs.version}";
    mainProgram = "zagel";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    platforms = lib.platforms.linux;
  };
})
