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
  version = "unstable-2020-07-17";

  src = fetchFromGitHub {
    owner = "aesophor";
    repo = "wmderland";
    rev = "a40a3505dd735b401d937203ab6d8d1978307d72";
    sha256 = "0npmlnybblp82mfpinjbz7dhwqgpdqc1s63wc1zs8mlcs19pdh98";
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
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ takagiy ];
    mainProgram = "wmderlandc";
  };
})
