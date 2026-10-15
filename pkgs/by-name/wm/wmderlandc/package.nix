{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libx11,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmderlandc";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "aesophor";
    repo = "wmderland";
    tag = finalAttrs.version;
    hash = "sha256-kzd5Wo+HruPC8R7UENyvjTOXBs0gmYWd5wVykr/DQHY=";
  };

  sourceRoot = "${finalAttrs.src.name}/ipc-client";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libx11
    xorgproto
  ];

  meta = {
    description = "Tiny program to interact with wmderland";
    homepage = "https://github.com/aesophor/wmderland/tree/master/ipc-client";
    changelog = "https://github.com/aesophor/wmderland/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ takagiy ];
    mainProgram = "wmderlandc";
  };
})
